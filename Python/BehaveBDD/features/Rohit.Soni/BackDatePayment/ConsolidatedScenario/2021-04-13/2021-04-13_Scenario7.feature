  Feature: Scenario 7.

    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

  Scenario: Post across cycle back-dated payment
    Given Post Payment_"1" of $"30" by trancode "2102" at "20210301151515"
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

  Scenario: Post across cycle back-dated payment
    Given Post Payment_"1" of $"30" by trancode "2102" at "20210301151515"
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"