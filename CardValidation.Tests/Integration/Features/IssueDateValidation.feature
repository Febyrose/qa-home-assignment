Feature: Issue Date Validation
  To prevent expired or invalid cards
  The system must validate the credit card's issue date format and expiry

  Background:
    Given the credit card validation API is accessible

  Scenario Outline: Accept valid future or current dates
    Given I input the credit card details:
      | Field  | Value        |
      | owner  | Leo John     |
      | number | 4333333333333333 |
      | date   | <date>       |
      | cvv    | 123          |
    When I submit the validation request
    Then the response status code should be 200

    Examples:
      | date     |
      | 12/2025  |
      | 01/30    |
      | 11/2028  |
      | 08/29    |

  Scenario Outline: Reject past or invalid dates
    Given I input the credit card details:
      | Field  | Value        |
      | owner  | Leo John     |
      | number | 4333333333333333 |
      | date   | <date>       |
      | cvv    | 123          |
    When I submit the validation request
    Then the response status code should be 400
    And an error message stating "Wrong date" should be returned

    Examples:
      | date     |
      | 01/2020  |
      | 00/2024  |
      | 13/2026  |
      | 12/2010  |
      | ab/cd    |

  Scenario: Missing date field
    Given I input the credit card details:
      | Field  | Value        |
      | owner  | Leo John     |
      | number | 4333333333333333 |
      | cvv    | 123          |
    When I submit the validation request
    Then the response status code should be 400
    And an error message stating "Date is required" should be returned

Scenario: Empty date field triggers validation error
    Given I input the credit card details:
      | Field  | Value       |
      | owner  | Leo John |
      | number | 4333333333333333 |
      | date   |      |
      | cvv    | 123         |
    When I submit the validation request
    Then the response status code should be 400
    And an error message stating "Date is required" should be returned
