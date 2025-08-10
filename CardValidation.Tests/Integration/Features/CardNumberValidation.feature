Feature: Credit Card Number Validation
  As a payment system
  I want to validate credit card numbers
  So that I can identify valid cards and reject invalid ones

  Background:
    Given the credit card validation API is accessible

  Scenario Outline: Recognize valid credit card numbers and return their type
    Given I input the credit card details:
      | Field  | Value        |
      | owner  | Leo John  |
      | number | <cardNumber> |
      | date   | 11/2026      |
      | cvv    | 123          |
    When I submit the validation request
    Then the response should be successful with status code 200
    And the detected card type should be "<cardType>"

    Examples:
      | cardNumber          | cardType        |
      | 4333333333333333    | 10           |
      | 4234123412341234    | 10           |
      | 5555555555554444    | 20      |
      | 5151515151515151    | 20      |
      | 2221523612358523    | 20      |
      | 2720999999999996    | 20      |
      | 378282246310005     | 30 |
      | 348282246310005     | 30 |

  Scenario Outline: Reject unsupported or malformed card numbers
    Given I input the credit card details:
      | Field  | Value        |
      | owner  | Leo John  |
      | number | <cardNumber> |
      | date   | 11/2026      |
      | cvv    | 123          |
    When I submit the validation request
    Then the response status code should be 400
    And an error message stating "Wrong number" should be returned

    Examples:
      | cardNumber           |
      | 6011111111111117     |
      | 3530111333300000     |
      | 4111-1111-1111-1111  |
      | abcdefghijklmnop     |
      | 12345678901234567    |
      | 411111111111111a     |

  Scenario: Omitted card number field triggers validation error
    Given I input the credit card details:
      | Field  | Value       |
      | owner  | Leo John |
      | date   | 11/2026     |
      | cvv    | 123         |
    When I submit the validation request
    Then the response status code should be 400
    And an error message stating "Number is required" should be returned

  Scenario: Empty card number field triggers validation error
    Given I input the credit card details:
      | Field  | Value       |
      | owner  | Leo John |
      | number |             |
      | date   | 11/2026     |
      | cvv    | 123         |
    When I submit the validation request
    Then the response status code should be 400
    And an error message stating "Number is required" should be returned

