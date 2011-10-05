Feature: facebook users should be able to view friends and determine top wall commenters

  Scenario: Logged in users should have access to their correctly paged friends
    Given I am logged in
    When I visit the index
    And I click the Friends link
    Then I should see the following friends:
    | name           |
    | Aaron Boswell  |
    | Aaron Holladay |
    | Andrew Crowley |
    And I should not see the following friends:
    | name     |
    | Van Pham |

  Scenario: Logged in users should be able to scroll forward through their friends list using the plus link
    Given I am logged in
    When I visit the index
    And I click the Friends link
    And I click the + link
    Then I should not see the following friends:
    | name          |
    | Aaron Boswell |
    And I should see the following friends:
    | name             |
    | Van Pham         |
    | Troy Thomas      |
    | Barbara Stoerner |

  Scenario: Logged in users should be able to scroll backwards through their friends list using the minus link
    Given I am logged in
    When I visit the index
    And I click the Friends link
    And I click the + link
    And I click the - link
    Then I should see the following friends:
    | name          |
    | Aaron Boswell |
    And I should not see the following friends:
    | name     |
    | Van Pham |
    
  Scenario Outline: Logged in users should be able to use the alphabet links at the top of the Friends List
    Given I am logged in
    When I visit the index
    And I click the Friends link
    And I click the <letter> link
    Then I should see the following friends:
    | name         |
    | <should_see> |
    And I should not see the following friends:
    | name             |
    | <should_not_see> |
    
  Scenarios: Alphabet Tests
    | letter | should_see    | should_not_see |
    | B      | Bankim Tejani | Andrew Crowley |
    | T      | Trey Denson   | Aaron Boswell  |
    | V      | Van Pham      | Aaron Boswell  |
    | A      | Aaron Boswell | Van Pham       |
    
  Scenario: Logged in users should be able to view friends top commenters when there is only one top commenter
    Given I am logged in
    When I visit the index
    And I click the Friends link
    And I click the Aaron Boswell link
    Then I should see the following friends:
    | name                               |
    | Collin Williams - Post comments: 1 |
    And I should see the following text Aaron Boswell's commenter is

  Scenario: Logged in users should be able to view friends top commenters when there are multiple top commenters
    Given I am logged in
    When I visit the index
    And I click the Friends link
    And I click the Amber Knight link
    Then I should see the following friends:
    | name                               |
    | Collin Williams - Post comments: 2 |
    | Chris Sherwyn - Post comments: 1   |
    And I should see the following text Amber Knight's commenters are

  Scenario: Logged in users should be able to view friends top commenters when there are no commenters
    Given I am logged in
    When I visit the index
    And I click the Friends link
    And I click the Adrian Thomas link
    Then I should see the following text Nobody has commented on any posts on Adrian Thomas's wall!
  
