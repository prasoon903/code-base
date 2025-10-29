Feature: Scenario 15.1

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-03-02" Date

Scenario: Create Account With BillingCycle 7
  Given Create Account
      |JsonTag    |Value      |
      |ProductID  |7131       |
      |StoreName  |JazzStore  |
      |BillingCycle | 7 |
      |CreditLimit | 10000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post Promo Purchase Transaction $200 and Cash Transaction of $100
  Given execute Post promopurchase_1 of $200 by trancode 4005 on CPM 13756
  Then Wait for 60 seconds
  Given execute Post cashpurchase_1 of $100 by trancode 3001 on CPM 13748
  # Then Verify Transaction in DB

Scenario: Age system statement-1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-03-08" Date

Scenario: Age system statement-2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-08" Date

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-27" Date

Scenario: Post Payment of min due + $30
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_1 of $AmountOfTotalDue+30 by trancode 2102
  # Then Verify Transaction in DB

Scenario: Post purchase and cash reversal
  Given execute Post purchase reversal of promopurchase_1
  Given execute Post purchase reversal of cashpurchase_1
  # Then Verify Transaction in DB