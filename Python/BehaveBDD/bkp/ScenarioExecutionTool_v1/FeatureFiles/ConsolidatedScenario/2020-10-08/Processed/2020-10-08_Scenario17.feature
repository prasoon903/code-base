Feature: Scenario 17

Background:
  Given Run as "rerun"

#Scenario: Post payment of amount greater than CB of BT Plan

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
