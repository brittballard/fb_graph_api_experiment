Feature: facebook users should be able to view friends and determine top wall commenters

  Scenario: Logged in users should have access to their friends
    Given I am logged in
    When I visit the index
    And I click the Friends link
    Then I should see the following friends:
    | name           |
    | Aaron Boswell  |
    | Aaron Holladay |
    | Andrew Crowley |
