Feature: Post across cycle backdated payment of AmountDue and SRB

Background:
  Given Run as "new"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-04-02" Date

Scenario: Create Account With BillingCycle 8
  Given Create Account
      |JsonTag    |Value      |
      |ProductID  |7131       |
      |StoreName  |JazzStore  |
      |BillingCycle | 8 |
      |CreditLimit | 10000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post purchase and Cash Transaction
  Given execute Post purchase_1 of $1000 by trancode 4005
  Then Wait for 60 seconds
  Given execute Post cashpurchase_1 of $500 by trancode 3001 on CPM 13748
  # Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-12" Date


Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-05-10" Date


Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_1 of $AmountOfTotalDue by trancode 2102
  # Then Verify Transaction in DB

Scenario: Post payment of SRB
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_1 of $StatementRemainingBalanceWithInstallmentDue by trancode 2102
  # Then Verify Transaction in DB