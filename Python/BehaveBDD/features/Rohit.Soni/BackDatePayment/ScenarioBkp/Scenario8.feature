#1.02/04/2021 Post Revolving Purchase and Cash Advance
#2.12/04/2021 Age one cycle (BC is 8)(Statement will done on 08/04/2021)
#3. No payment and age 2nd cycle (2nd Statement 08/05/2021)
#4. 09/05/2021 Post an across cycle backdated payment of amount equal to previous cycle Statement Remaining Balance (SRB)

Feature: Post across cycle backdated payment of SRB

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
  Given Post purchase of $"1000" by trancode "4005"
  Given Post cash purchase of $"500" by trancode "3001" and "13748"
  Then  Age system to "2021-04-12" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-05-09" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Post payment of StatementRemainingBalanceWithInstallmentDue
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"StatementRemainingBalanceWithInstallmentDue" by trancode "2102" at "20210509151515"
  Then Verify Transaction in DB
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"