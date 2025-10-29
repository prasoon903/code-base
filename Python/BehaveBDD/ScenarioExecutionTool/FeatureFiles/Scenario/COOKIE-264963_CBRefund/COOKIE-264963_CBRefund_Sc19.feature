Feature: COOKIE-264963_CBRefund_Sc19

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
  

Scenario: Post retail purchase 1
  Given execute Post retailpurchase_1 of $300 by trancode F4005 on CPM 13794
  Given execute add Bank for Bank_1
  
Scenario: Post revolving purchase 1
  Given execute Post purchase_1 of $250 by trancode 4005
  
Scenario: Post revolving purchase 2
  Given execute Post purchase_2 of $500 by trancode 4005
  
Scenario: Age upto statement 1
  Given Test Given
  Then  Age system to "2018-03-06" Date
  
Scenario: Post Payment_1
  Given execute Post payment_1 of $800 by trancode 2102
  Then  Age system to "2018-04-05" Date
  
Scenario: Add dispute of purchase_1
  Given execute Post Dispute_1 of $250 for purchase_1
  Then  Age system to "2018-04-08" Date
  
Scenario: Post retail purchase 2
  Given execute Post retailpurchase_2 of $1200 by trancode F4005 on CPM 13800
  Then  Age system to "2018-04-10" Date
  
Scenario: Add dispute of purchase_2
  Given execute Post Dispute_2 of $500 for purchase_2
  Then  Age system to "2018-04-10" Date
  
Scenario: Post dispute resolution of purchase_2
  Given execute Post disputeresolution_1 of $500 for Dispute_2 with action 2
  

  

