Feature: Test account Test Case 146314 Without Posting 2

Background:
  Given Run as "rerun"

Scenario: Create Account With BillingCycle 31
  Given Create Account
      |JsonTag      |  Value       |
      |ProductID    |  7131        |
      |StoreName    |  CookieStore |
      |BillingCycle |  31          |
      |CreditLimit  |  10000       |
      |AccountCreationDateTime  | 20170206     |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Disable Posting2.0
  Given Test Given
  When Disable Posting2.0
  Then Wait for 60 seconds      

Scenario: Post purchase 1
  Given execute Post purchase_1 of $5000 by trancode 4005
  Then Wait for 60 seconds
  #Then Verify Transaction in DB

Scenario: Age TestAccount Statement-1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age TestAccount to "2017-03-01" Date

Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_1 of $AmountOfTotalDue by trancode 2102
  # Then Verify Transaction in DB
    
Scenario: Age TestAccount
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age TestAccount to "2017-05-01" Date
  
Scenario: Post Backdate Payment_2
  Given execute Post payment_2 of $PastDue by trancode 2102 at 20170423050505
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  # Then Verify Transaction in DB  

Scenario: Age TestAccount
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age TestAccount to "2017-07-01" Date
	
Scenario: Post Backdate Payment_3
  Given execute Post payment_3 of $150 by trancode 2102 at 20170623050506
  Then Wait for 60 seconds
  #Then Verify Transaction in DB
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"


Scenario: Post Backdate Payment_4
  Given execute Post payment_4 of $150 by trancode 2102 at 20170523050507
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Get Account Plan Details
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  
Scenario: Age TestAccount
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"  
  And Age TestAccount to "2017-07-02" Date
