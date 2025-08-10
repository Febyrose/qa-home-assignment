Feature: Card Owner Name Validation
  To ensure only valid names are accepted
  The system should validate the credit card owner's name format

  Background:
    Given the credit card validation API is accessible

  Scenario Outline: Accept valid owner names
    Given I input the credit card details:
      | Field  | Value        |
      | owner  | <owner>      |
      | number | 4333333333333333 |
      | date   | 12/2026      |
      | cvv    | 123          |
    When I submit the validation request
    Then the response status code should be 200

    Examples:
      | owner          |
      | Leo John       |
      | A B C  |
      | Leo Abey John   |
      | ABEY JOHN |
      | A |

  Scenario Outline: Reject invalid owner names
    Given I input the credit card details:
      | Field  | Value        |
      | owner  | <owner>      |
      | number | 4333333333333333 |
      | date   | 12/2026      |
      | cvv    | 123          |
    When I submit the validation request
    Then the response status code should be 400
    And an error message stating "Wrong owner" should be returned

    Examples:
      | owner        |
      | Leo123      |
      | !@#$$%       |
      | Leo_John     |

  Scenario: Missing owner field
    Given I input the credit card details:
      | Field  | Value        |
      | number | 4333333333333333 |
      | date   | 12/2026      |
      | cvv    | 123          |
    When I submit the validation request
    Then the response status code should be 400
    And an error message stating "Owner is required" should be returned

Scenario: Empty owner field
    Given I input the credit card details:
      | Field  | Value        |
      | owner  |       |
      | number | 4333333333333333 |
      | date   | 12/2026      |
      | cvv    | 123          |
    When I submit the validation request
    Then the response status code should be 400
    And an error message stating "Owner is required" should be returned
