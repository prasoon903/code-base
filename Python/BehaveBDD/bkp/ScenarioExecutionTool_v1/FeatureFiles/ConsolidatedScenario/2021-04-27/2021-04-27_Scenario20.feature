Feature: Scenario 20

Background:
  Given Run as "rerun"

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
