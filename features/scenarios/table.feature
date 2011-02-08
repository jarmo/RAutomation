Feature: Table support
  In order to test table features
  As a tester
  I want to be able to interact with tables

  Scenario: Find a table
    Given I am on the main form
    When I press data entry form button
    Then I see the table:
      | Name     | Date of birth |
      | John Doe | 12/15/1967    |
      | Anna Doe | 3/4/1975      |