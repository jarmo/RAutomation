Feature: Combo box feature
  In order to test combo box features
  As a RAutomation user
  I want to be able to interact with tables

  Scenario: Use a combo box
    Given I am on the main form
    When I don't selected anything on the combo box
    Then I expect to "" in the combo box

  Scenario: Use a combo box on a different project
    Given I am on the main form
    When I select "Caimito" in the combo box
    Then I expect to "Caimito" in the combo box

  Scenario: Use a combo box on a different project
    Given I am on the main form
    When I select "Orange" in the combo box
    Then I expect to "Orange" in the combo box