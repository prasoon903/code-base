Feature: Verify delinquency should not impact when two payments of same amount was made and
  one would get reversed on next cycle.Also verify the distribution after payment reversal.
  Background:
    Given Run as "new"

  Scenario: Post Payment-1 reversal
      Given Post Payment Reversal of "Payment_1"
      Then Verify Transaction in DB
      Given Get AccountSummary
      Then Save tag into variable "AccountSummary"

  Scenario: Post Backdate Payment-1
      Given Post Payment_"3" of $"20" by trancode "2108" at "20210413151515"


  Scenario: Post Payment-2 reversal
    Given Post Payment Reversal of "Payment_2"
    Then Verify Transaction in DB
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

  Scenario: Post Backdate Payment-2
    Given Post Payment_"4" of $"29" by trancode "2108" at "20210413161515"
    Then Verify Transaction in DB
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

  Scenario: Post Backdate Payment-1 Reversal
    Given Post Payment Reversal of "Payment_3"
    Then Verify Transaction in DB
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

  Scenario: Post Backdate Payment-2 Reversal
      Given ost Payment Reversal of "Payment_4"
      Then Verify Transaction in DB