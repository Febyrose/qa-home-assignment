Feature: CVV Code Validation
  CVV codes should be checked for proper length and format

  Background:
    Given the credit card validation API is accessible

  Scenario Outline: Accept valid CVV codes
    Given I input the credit card details:
      | Field  | Value        |
      | owner  | Leo John     |
      | number | 4333333333333333 |
      | date   | 12/2026      |
      | cvv    | <cvv>        |
    When I submit the validation request
    Then the response status code should be 200

    Examples:
      | cvv   |
      | 123   |
      | 456   |
      | 7890  |

  Scenario Outline: Reject invalid CVV codes
    Given I input the credit card details:
      | Field  | Value        |
      | owner  | Leo John     |
      | number | 4333333333333333 |
      | date   | 12/2026      |
      | cvv    | <cvv>        |
    When I submit the validation request
    Then the response status code should be 400
    And an error message stating "Wrong cvv" should be returned

    Examples:
      | cvv   |
      | abc   |
      | 12    |
      | 12345 |

  Scenario: Missing CVV field
    Given I input the credit card details:
      | Field  | Value        |
      | owner  | Leo John     |
      | number | 4333333333333333 |
      | date   | 12/2026      |
    When I submit the validation request
    Then the response status code should be 400
    And an error message stating "Cvv is required" should be returned

Scenario: Empty CVV field
    Given I input the credit card details:
      | Field  | Value        |
      | owner  | Leo John     |
      | number | 4333333333333333 |
      | date   | 12/2026      |
      | cvv    |         |
    When I submit the validation request
    Then the response status code should be 400
    And an error message stating "Cvv is required" should be returned
