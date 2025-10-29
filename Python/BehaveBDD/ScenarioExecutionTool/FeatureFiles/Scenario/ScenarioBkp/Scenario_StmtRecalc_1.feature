Feature: Scenario Statement recalculation v1

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2018-03-10" Date

Scenario: Create Account With BillingCycle 31
  Given Create Account
      |JsonTag    |Value      |
      |ProductID  |7131       |
      |StoreName  |CookieStore  |
      |BillingCycle | 31 |
      |CreditLimit | 10000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post purchase and Cash Transaction
  Given execute Post purchase_1 of $1000 by trancode 4005
  Given execute Post purchase_2 of $1200 by trancode F4005 on CPM 13776
  Then Age system to "2018-05-01" Date

Scenario: Step 1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_1 of $AmountOfTotalDue by trancode 2102
  Then Wait for 60 seconds
  Then Age system to "2018-06-01" Date
  
Scenario: Step 2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post payment reversal of payment_1
  Given execute Post Payment_2 of $AmountOfTotalDue by trancode 2102 at 20180425010101
  Then Wait for 60 seconds
  Given execute Post Payment_3 of $AmountOfTotalDue by trancode 2102
  Then Wait for 60 seconds
  Given execute Post Payment_4 of $AmountOfTotalDue by trancode 2102
  Then Wait for 60 seconds
  Then Age system to "2018-07-01" Date

Scenario: Step 3
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_5 of $AmountOfTotalDue by trancode 2102
  