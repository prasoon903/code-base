Feature: Scenario 18

Background:
  Given Run as "rerun"

Scenario: Post Purchase return
  Given Post purchase return of $"149" by trancode "4103"
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
