@core @core_badges @_file_upload @javascript
Feature: Manage badges is not shown when there are no existing badges.

  Scenario: Check navigation at site level with no badges
    Given I log in as "admin"
    When I navigate to "Badges > Manage badges" in site administration
    And I should see "There are no badges available"
    Then "Manage badges" "button" should not exist

  Scenario: Check navigation at course level with no badges
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | teacher  | Teacher | 1 | teacher@example.com |
    And the following "courses" exist:
      | fullname | shortname | format | enablecompletion |
      | Course 1 | C1        | topics | 1                |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher | C1     | editingteacher |
    And I log in as "teacher"
    And I am on "Course 1" course homepage
    When I follow "Badges"
    Then "Manage badges" "button" should exist
    And I click on "Add a new badge" "button"
    And I set the following fields to these values:
      | Name | Testing course badge |
      | Version | 1.1 |
      | Language | Basque |
      | Description | Testing course badge description |
      | Image author | http://author.example.com |
      | Image caption | Test caption image |
    And I upload "badges/tests/behat/badge.png" file to "Image" filemanager
    And I click on "Create badge" "button"
    And I set the field "type" to "Manual issue by role"
    And I expand all fieldsets
    And I set the field "Teacher" to "1"
    And I click on "Save" "button"
    And I click on "Manage badges" "link"
    And I should see "Testing course badge"
    And I follow "Badges"
    # Badge is not enabled yet so is not listed.
    And I should not see "Testing course badge"
    And I should see "There are no badges available."
    And I click on "Manage badges" "button"
    And I click on "Enable access" "link" in the "Testing course badge" "table_row"
    And I click on "Continue" "button"
    And I should see "Testing course badge"
    And I follow "Badges"
    # Badge is already enabled so is listed.
    And I should see "Testing course badge"
    And I should not see "There are no badges available."

  Scenario: Check navigation at course level with no badges as a student
    # Create a badge, but leave it not enabled for now.
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | student1 | Student   | 1        | student1@example.com |
    And the following "courses" exist:
      | fullname | shortname | format | enablecompletion |
      | Course 1 | C1        | topics | 1                |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | student1 | C1     | student        |
    And I am on the "C1" "Course" page logged in as "admin"
    And I navigate to "Badges > Add a new badge" in current page administration
    And I set the following fields to these values:
      | Name | Testing course badge |
      | Version | 1.0 |
      | Language | Catalan |
      | Description | Testing course badge description |
    And I upload "badges/tests/behat/badge.png" file to "Image" filemanager
    And I press "Create badge"
    And I set the field "type" to "Manual issue by role"
    And I expand all fieldsets
    And I set the field "Teacher" to "1"
    And I press "Save"
    And I log out
    When I am on the "C1" "Course" page logged in as "student1"
    Then "Badges" "link" should not exist in current page administration
    And I log out
    # Enable the badge.
    And I am on the "C1" "Course" page logged in as "admin"
    And I follow "Badges"
    And I click on "Manage badges" "button"
    And I click on "Enable access" "link" in the "Testing course badge" "table_row"
    And I press "Continue"
    And I log out
    # Now student should see the Badges link.
    And I am on the "C1" "Course" page logged in as "student1"
    And I follow "Badges"
    And "Manage badges" "button" should not exist
    And "Add a new badge" "button" should not exist
    And I should not see "There are no badges available."
