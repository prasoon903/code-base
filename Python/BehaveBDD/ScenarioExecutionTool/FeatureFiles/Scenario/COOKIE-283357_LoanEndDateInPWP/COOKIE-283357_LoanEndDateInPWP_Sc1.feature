Feature: COOKIE-283357_LoanEndDateInPWP_Sc1

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
  Given execute Post purchase_1 of $1000 by trancode 4005
  
Scenario: Post retail purchase 1
  Given execute Post retailpurchase_1 of $1200 by trancode F4005 on CPM 13776
  
Scenario: Add bank
  Given execute add Bank for Bank_1
  
Scenario: Age system Statement-1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2018-03-06" Date
  
Scenario: Age system Statement-2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2018-04-06" Date
  
Scenario: Post Payment_1
  Given execute Post payment_1 of $500 by trancode 2102
  
Scenario: Add dispute of purchase_1
  Given execute Post Dispute_1 of $300 for purchase_1