Feature: Scenario 19

Background:
  Given Run as "rerun"

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

#Scenario: Post Payment of Current balance of Cash Plan
#
#Scenario: Post Payment of Current balance of Purchase Plan