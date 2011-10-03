Feature: facebook users should be able to view friends and determine top wall commenters

  Scenario: Logged in users should have access to their friends
    Given I am logged in
    When I visit the index
    Then I should see a Friends link