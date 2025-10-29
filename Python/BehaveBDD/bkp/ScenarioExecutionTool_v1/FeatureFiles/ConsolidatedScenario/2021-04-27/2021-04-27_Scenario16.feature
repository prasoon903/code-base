Feature: Scenario 16

Background:
  Given Run as "rerun"

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

#Scenario: Post dispute
#  Given Post dispute of $1200
#  Given Post dispute of $500
#  Then Verify Transaction in DB