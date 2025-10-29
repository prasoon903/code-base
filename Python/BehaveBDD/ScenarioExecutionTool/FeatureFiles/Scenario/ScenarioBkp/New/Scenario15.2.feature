Feature: Scenario 15.2

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

Scenario: Age system to statement-1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-03-08" Date

Scenario: Age system statement-2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-08" Date

Scenario: Post Purchase Transaction $100
  Given execute Post purchase_1 of $1000 by trancode 4005
  # Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-05-02" Date

Scenario: Post Payment of min due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_1 of $AmountOfTotalDue by trancode 2102
  # Then Verify Transaction in DB

Scenario: Age system statement-3
  Then  Age system to "2021-05-08" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-05-09" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-05-09" Date

Scenario: Post Payment of min due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_2 of $AmountOfTotalDue by trancode 2102
  # Then Verify Transaction in DB