Feature: COOKIE-264963_CBRefund_Sc4

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
  

Scenario: Post purchase 1
  Given execute Post purchase_1 of $500 by trancode 4005
  Given execute add Bank for Bank_1
  
Scenario: Age system Statement-1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2018-03-06" Date
  
Scenario: Post Payment_1
  Given execute Post payment_1 of $500 by trancode 2102
  
Scenario: Add dispute of purchase_1
  Given execute Post Dispute_1 of $300 for purchase_1
  Then  Age system to "2018-03-15" Date
  
Scenario: Post Purchase return
  Given execute Post return_1 of $200 by trancode 4103
  Then  Age system to "2018-05-05" Date
  
Scenario: Aging
    Given Test Given
    Then Age system to "2018-05-15" Date
	
Scenario: Run ACH batch
    Given Test Given
	Then Start ACHProcessStep_1
