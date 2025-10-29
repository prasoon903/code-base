Background:
  Given Run as "rerun"
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Post Payment of min due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"2" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB