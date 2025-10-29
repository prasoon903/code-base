Feature: Scenario 15.1

Background:
  Given Run as "rerun"

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Post Payment of min due + $30
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"AmountOfTotalDue+30" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

#Scenario: Post purchase and cash reversal
#  Given Post purchase reversal
#  Given Post cash reversal
#  Then Verify Transaction in DB