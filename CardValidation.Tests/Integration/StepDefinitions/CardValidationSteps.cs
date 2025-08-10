using System.Net;
using System.Text;
using System.Text.Json;
using FluentAssertions;
using Reqnroll;

namespace CardValidation.Tests.Integration.StepDefinitions
{
    [Binding]
    public class CardValidationStepDefinitions
    {
        private readonly HttpClient _httpClient;
        private readonly ScenarioContext _scenarioContext;
        private string _serviceUrl = string.Empty;
        private CreditCardRequest _creditCard = new();
        private HttpResponseMessage? _response;
        private string _responseContent = string.Empty;

        public CardValidationStepDefinitions(ScenarioContext scenarioContext)
        {
            var handler = new HttpClientHandler
            {
                ServerCertificateCustomValidationCallback = (sender, cert, chain, sslPolicyErrors) => true
            };

            _httpClient = new HttpClient(handler);
            _scenarioContext = scenarioContext;
        }


        [Given("the credit card validation API is accessible")]
        public void GivenTheCreditCardValidationAPIIsAccessible()
        {
            var baseUrl = Environment.GetEnvironmentVariable("TEST_API_URL") ?? "https://localhost:7135";
            _serviceUrl = $"{baseUrl}/CardValidation/card/credit/validate";
        }

        [Given("I input the credit card details:")]
        public void GivenIInputTheCreditCardDetails(Table table)
        {
            _creditCard = new CreditCardRequest();

            foreach (var row in table.Rows)
            {
                var field = row["Field"];
                var value = row["Value"];

                switch (field.ToLowerInvariant())
                {
                    case "owner":
                        _creditCard.Owner = value;
                        break;
                    case "number":
                        _creditCard.Number = value;
                        break;
                    case "date":
                        _creditCard.Date = value;
                        break;
                    case "cvv":
                        _creditCard.Cvv = value;
                        break;
                }
            }
        }

        [When("I submit the validation request")]
        public async Task WhenISubmitTheValidationRequest()
        {
            var json = JsonSerializer.Serialize(_creditCard, new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            });

            var content = new StringContent(json, Encoding.UTF8, "application/json");

            _response = await _httpClient.PostAsync(_serviceUrl, content);
            _responseContent = await _response.Content.ReadAsStringAsync();
        }

        [Then("the response status code should be (\\d+)")]
        public void ThenTheResponseStatusCodeShouldBe(int expectedStatusCode)
        {
            _response.Should().NotBeNull();
            ((int)_response!.StatusCode).Should().Be(expectedStatusCode);
        }

        [Then("the response should be successful with status code (\\d+)")]
        public void ThenTheResponseShouldBeSuccessfulWithStatusCode(int expectedStatusCode)
        {
            _response.Should().NotBeNull();
            ((int)_response!.StatusCode).Should().Be(expectedStatusCode);
        }

        [Then("the detected card type should be \"(.*)\"")]
        public void ThenTheDetectedCardTypeShouldBe(string expectedType)
        {
            _responseContent.Should().Contain(expectedType);
        }

        [Then("an error message stating \"(.*)\" should be returned")]
        public void ThenAnErrorMessageStatingShouldBeReturned(string expectedErrorMessage)
        {
            _responseContent.Should().Contain(expectedErrorMessage);
        }

        [AfterScenario]
        public void Cleanup()
        {
            _response?.Dispose();
        }

        public class CreditCardRequest
        {
            public string? Owner { get; set; }
            public string? Number { get; set; }
            public string? Date { get; set; }
            public string? Cvv { get; set; }
        }
    }
}
