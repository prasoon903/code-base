#1. 02/03/2021 Post Promo Purchase Transaction $200 and Cash Transaction of $100
#2. 08/03/2021 age till 1st statement
#3.08/04/2021 age till 2nd statement
#4.27/04/2021 Post Payment of min due + $30
#5.02/05/2021 Post Purchase reverse and cash reversal

Feature: Scenario 15.1

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-03-02" Date

Scenario: Create Account With BillingCycle 7
  Given Create Account
      |JsonTag    |Value      |
      |ProductID  |7131       |
      |StoreName  |JazzStore  |
      |BillingCycle | 7 |
      |CreditLimit | 10000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post Promo Purchase Transaction $200 and Cash Transaction of $100
  Given Post cash purchase of $"200" by trancode "4005" and "13756"
  Given Post cash purchase of $"500" by trancode "3001" and "13748"
  Then Verify Transaction in DB

Scenario: Age system to "2021-03-08" Date -- statement-1
  Then  Age system to "2021-03-08" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-04-08" Date -- statement-2
  Then  Age system to "2021-04-08" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-04-27" Date
  Then  Age system to "2021-04-27" Date

Scenario: Post Payment of min due + $30
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"AmountOfTotalDue+30" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Post purchase and cash reversal
  Given Post purchase reversal
  Given Post cash reversal
  Then Verify Transaction in DB