  Feature: Scenario 7.

    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

  Scenario: Post payment of $30 (Less than min due)
    Given Post Payment_"1" of $"30" by trancode "2102" at "20210213151515"
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

  Scenario: Post payment of $30 (Less than min due)
    Given Post Payment_"1" of $"30" by trancode "2102" at "20210213151515"
