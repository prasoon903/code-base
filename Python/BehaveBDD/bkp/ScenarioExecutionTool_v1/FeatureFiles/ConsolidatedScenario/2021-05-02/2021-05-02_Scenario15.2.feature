Background:
  Given Run as "rerun"

Scenario: Post Purchase Transaction $100
  Given Post purchase of $"1000" by trancode "4005"
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
