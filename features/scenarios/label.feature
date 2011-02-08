Feature: Label feature
  In order to test radio button features
  As a  a RAutomation user
  I want to be able to interact with tables

  Scenario: See if a label changes
    Given I am on the main form
    When I set the radio button to "Option 1"
    Then the selected label says "Option 1 selected"

  Scenario: See if a label changes
    Given I am on the main form
    When I set the radio button to "Option 2"
    Then the selected label says "Option 2 selected"