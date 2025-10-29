Feature: Verify delinquency should not impact when two payments of same amount was made and
  one would get reversed on next cycle.Also verify the distribution after payment reversal.
  Background:
    Given Run as "new"



  Scenario: Post payment of min due
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"
    Given Post Payment_"1" of $"29" by trancode "2102" at "posttime"


  Scenario: Post payment of min due again
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"
    Given Post Payment_"2" of $"29" by trancode "2108" at "posttime"
