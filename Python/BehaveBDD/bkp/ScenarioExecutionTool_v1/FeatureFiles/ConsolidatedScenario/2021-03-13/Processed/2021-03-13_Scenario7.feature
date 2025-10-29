 Feature: Scenario 7.

 Background:
   Given Run as "rerun"


  Scenario: Post payment of $30 (Less than min due)
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"
    Given Post Payment_"1" of $"30" by trancode "2102" at "posttime"
