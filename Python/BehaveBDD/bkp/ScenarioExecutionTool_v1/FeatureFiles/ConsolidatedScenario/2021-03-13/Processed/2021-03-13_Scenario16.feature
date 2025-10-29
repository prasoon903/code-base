Feature: Scenario 16

Background:
  Given Run as "rerun"

Scenario: Post Purchase Transaction
  Given Post purchase of $"500" by trancode "4005"
  Then Verify Transaction in DB

Scenario: Age system statement-2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
