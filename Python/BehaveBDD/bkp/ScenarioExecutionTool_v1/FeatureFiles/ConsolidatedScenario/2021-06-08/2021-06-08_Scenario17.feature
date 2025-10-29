Feature: Scenario 17

Background:
  Given Run as "rerun"

Scenario: Post Payment of SRB
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"4" of $"StatementRemainingBalanceWithInstallmentDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

#Scenario: Update billing table 11153 to account

Scenario: Post Purchase, cash and BT Transaction
  Given Post purchase of $"50" by trancode "4005"
  Then Wait for "60" seconds
  Given Post cash purchase of $"29.5" by trancode "4005" and "13746"
  Then Wait for "60" seconds
  Given Post cash purchase of $"25" by trancode "3001" and "13748"
  Then Verify Transaction in DB

Scenario: Age till account become Charged Off
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
