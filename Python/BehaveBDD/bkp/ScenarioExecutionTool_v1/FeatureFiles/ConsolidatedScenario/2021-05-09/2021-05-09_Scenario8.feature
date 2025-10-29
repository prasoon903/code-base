Feature: Post across cycle backdated payment of SRB

Background:
  Given Run as "new"

  Scenario: GetAccountSummary
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

Scenario: Post payment of StatementRemainingBalanceWithInstallmentDue
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"StatementRemainingBalanceWithInstallmentDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"