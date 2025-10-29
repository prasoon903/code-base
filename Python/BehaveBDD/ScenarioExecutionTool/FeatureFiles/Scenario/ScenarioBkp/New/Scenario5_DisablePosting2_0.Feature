Feature: Scenario5(Test Case - 143763 Without Posting 2.O)

  Background:
    Given Run as "rerun"

  Scenario: Test Given
    Given Test Given
    Then Age system to "2018-02-10" Date

  Scenario: Create Account With BillingCycle 31
    Given Create Account
      |JsonTag    |Value      |
      |ProductID  |7131       |
      |StoreName  |CookieStore  |
      |BillingCycle | 31 |
      |CreditLimit | 10000 |
    Then Verify Account Number in Database
    And Save tag into variable "AccountCreation"
    And Age system to "2018-02-11" Date

  Scenario: Disable Posting2.0
    Given Test Given
    When Disable Posting2.0

  Scenario: Post purchase 1
    Given execute Post purchase_1 of $5000 by trancode 4005
    Then Wait for 60 seconds
    Then  Age system to "2018-05-01" Date
	
	
  Scenario: Post Post Dispute
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"
    Given execute Post Dispute_1 of $4990 for purchase_1
    Then  Age system to "2018-06-01" Date		

	

