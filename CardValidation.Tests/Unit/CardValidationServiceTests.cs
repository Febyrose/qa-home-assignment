using CardValidation.Core.Enums;
using CardValidation.Core.Services;
using CardValidation.Core.Services.Interfaces;

namespace CardValidation.Tests.Unit
{
    public class CardValidationServiceTests
    {
        private readonly ICardValidationService _service;

        public CardValidationServiceTests()
        {
            _service = new CardValidationService();
        }
        [Fact]
        public void ValidateNumber_ShouldReturnTrue_WhenVisaCardIsValid()
        {
            // Arrange
            var visacardnumber = "4234123412341234";
            // Act
            var result = _service.ValidateNumber(visacardnumber);
            // Assert
            Assert.True(result);
        }

        [Fact]
        public void ValidateNumber_ShouldReturnTrue_ForValid13DigitVisaCard()
        {
            // Arrange
            var thirteenDigitVisa = "4123456789012"; // Valid 13-digit Visa

            // Act
            var result = _service.ValidateNumber(thirteenDigitVisa);

            // Assert
            Assert.True(result);
        }

        [Fact]
        public void ValidateNumber_ShouldReturnTrue_ForValid16DigitVisaCard()
        {
            // Arrange
            var sixteenDigitVisa = "4111111111111111"; // Valid 16-digit Visa

            // Act
            var result = _service.ValidateNumber(sixteenDigitVisa);

            // Assert
            Assert.True(result);
        }

        [Fact]
        public void ValidateNumber_ShouldReturnFalse_ForVisaCardWithLessThan13Digits()
        {
            // Arrange
            var shortVisa = "411111111111"; // 12 digits

            // Act
            var result = _service.ValidateNumber(shortVisa);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void ValidateNumber_ShouldReturnFalse_ForVisaCardWithMoreThan16Digits()
        {
            // Arrange
            var longVisa = "4111111111111111222"; // 19 digits

            // Act
            var result = _service.ValidateNumber(longVisa);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void ValidateNumber_ShouldReturnTrue_WhenMasterCardIsValid()
        {
            // Arrange
            var mastercardnumber = "5555555555554444";
            // Act
            var result = _service.ValidateNumber(mastercardnumber);
            // Assert
            Assert.True(result);
        }

        [Fact]
        public void ValidateNumber_ShouldReturnTrue_WhenMasterCardStartingWith2IsValid()
        {
            // Arrange
            var amexcardnumber = "2221523612358523";
            // Act
            var result = _service.ValidateNumber(amexcardnumber);
            // Assert
            Assert.True(result);
        }

        [Fact]
        public void ValidateNumber_ShouldReturnTrue_WhenAmExCardStartingWith37IsValid()
        {
            // Arrange
            var amexcardnumber = "378282246310005";
            // Act
            var result = _service.ValidateNumber(amexcardnumber);
            // Assert
            Assert.True(result);
        }

        [Fact]
        public void ValidateNumber_ShouldReturnTrue_WhenAmExCardStartingWith34IsValid()
        {
            // Arrange
            var amexcardnumber = "348282246310005";
            // Act
            var result = _service.ValidateNumber(amexcardnumber);
            // Assert
            Assert.True(result);
        }

        [Theory]
        [InlineData("1111111111111111")]  // Invalid Visa prefix
        [InlineData("411111111111")]      // Visa too short
        [InlineData("5612345678901234")]  // MasterCard invalid prefix
        [InlineData("510510510510")]      // MasterCard too short
        [InlineData("361449635398431")]   // AmEx invalid prefix
        [InlineData("37144963539843")]    // AmEx too short
        [InlineData("abcd1234efgh5678")]  // Non-numeric
        [InlineData("")]                  // Empty string
        [InlineData(null)]               // Null input
        public void ValidateNumber_ShouldReturnFalse_ForInvalidCardNumbers(string cardNumber)
        {
            // Act
            var result = _service.ValidateNumber(cardNumber ?? string.Empty);

            // Assert
            Assert.False(result);
        }

        [Theory]
        [InlineData("Leo John", true)]
        [InlineData("ABEY JOHN", true)]
        [InlineData("L", true)]
        [InlineData("Leo Abey John", true)]
        [InlineData("Leo Abey John S", false)]
        [InlineData(" Leo", false)]      // Leading space
        [InlineData("Leo ", false)]      // Trailing space
        [InlineData("111", false)]
        [InlineData("", false)]
        [InlineData("Leo123", false)]
        [InlineData("Leo@", false)]
        public void ValidateOwner_ShouldReturnTrueforValid_FalseforInvalidNames(string name, bool expected)
        {
            var result = _service.ValidateOwner(name);
            Assert.Equal(expected, result);
        }

        [Theory]
        [InlineData("12/30", true)]
        [InlineData("01/2026", true)]
        [InlineData("08/50", true)]
        [InlineData("09/2099", true)]
        [InlineData("1/30", false)]
        [InlineData("13/2025", false)]
        [InlineData("00/24", false)]
        [InlineData("0826", false)]
        [InlineData("08-26", false)]
        [InlineData("2026/08", false)]
        [InlineData("08/20267", false)]
        [InlineData("08", false)]
        [InlineData(" ", false)]
        public void ValidateIssueDate_ShouldReturnExpected(string date, bool expected)
        {
            var result = _service.ValidateIssueDate(date);
            Assert.Equal(expected, result);

        }

        [Theory]
        [InlineData("123", true)]
        [InlineData("1234", true)]
        [InlineData("11", false)]
        [InlineData("22222", false)]
        [InlineData("abcd", false)]
        [InlineData("33b", false)]
        [InlineData("", false)]
        public void ValidateCvc_ShouldReturnExpected(string cvc, bool expected)
        {
            var result = _service.ValidateCvc(cvc);
            Assert.Equal(expected, result);
        }

        [Fact]
        public void GetPaymentSystemType_ShouldReturnVisa()
        {
            var result = _service.GetPaymentSystemType("4234123412341234");
            Assert.Equal(PaymentSystemType.Visa, result);
        }

        [Fact]
        public void GetPaymentSystemType_ShouldReturnMasterCard()
        {
            var result = _service.GetPaymentSystemType("5555555555554444");
            Assert.Equal(PaymentSystemType.MasterCard, result);
        }

        [Fact]
        public void GetPaymentSystemType_ShouldReturnAmExCard()
        {
            var result = _service.GetPaymentSystemType("378282246310005");
            Assert.Equal(PaymentSystemType.AmericanExpress, result);
        }
    }
}


