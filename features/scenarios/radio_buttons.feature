Feature: Radio button feature

  Scenario: Set a radio button
    Given I am on the main form
    When I set the radio button to "Option 1"
    Then I the radio button "Option 1" should be set
    Then I the radio button "Option 2" should be not set

  Scenario: Set a radio button
    Given I am on the main form
    When I set the radio button to "Option 2"
    Then I the radio button "Option 2" should be set
    Then I the radio button "Option 1" should be not set
