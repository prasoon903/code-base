Feature: Post across cycle backdated payment of AmountDue and SRB

Background:
  Given Run as "new"


Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"


Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Post payment of SRB
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"StatementRemainingBalanceWithInstallmentDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB