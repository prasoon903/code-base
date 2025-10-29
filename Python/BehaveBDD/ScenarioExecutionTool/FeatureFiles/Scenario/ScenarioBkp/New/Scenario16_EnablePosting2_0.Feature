Feature: Scenario16(Test Case - 146329 With Posting 2.O)

  Background:
    Given Run as "rerun"

  Scenario: Test Given
      Given Test Given
      Then Age system to "2021-08-05" Date

  Scenario: Create Account With BillingCycle 2
      Given Create Account
          |JsonTag    |Value      |
          |ProductID  |7131       |
          |StoreName  |JazzStore  |
          |BillingCycle | 2 |
          |CreditLimit | 10000 |
      Then Verify Account Number in Database
      And Save tag into variable "AccountCreation"
	    And Age system to "2021-08-06" Date

    Scenario: Enable Posting2.0
      Given Test Given
      Then Wait for 60 seconds
      When Enable Posting2.0
      Then Wait for 60 seconds    

  Scenario: Post purchase 
    Given execute Post purchase_1 of $1000 by trancode 4005
    Then Wait for 60 seconds
    # Then Verify Transaction in DB
    Then  Age system to "2021-08-08" Date

  Scenario: Post cash purchase with billingtable 12587
    Given execute Post cashpurchase_1 of $100 by trancode 3001 on CPM 13748
    Then Wait for 60 seconds
    # Then Verify Transaction in DB
    Then  Age system to "2021-10-03" Date	  

  Scenario: Post Backdate Payment_1
    Given execute Post payment_1 of $29 by trancode 2102 at 20210926050505
    #Then Verify Transaction in DB
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"
	  Then  Age system to "2021-10-05" Date
    
