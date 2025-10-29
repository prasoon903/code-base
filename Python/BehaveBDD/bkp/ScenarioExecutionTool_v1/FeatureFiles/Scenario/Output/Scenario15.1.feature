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
  Then Wait for "60" seconds
  Given Post cash purchase of $"500" by trancode "3001" and "13748"
  Then Verify Transaction in DB

Scenario: Age system statement-1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-03-08" Date

Scenario: Age system statement-2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-08" Date

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-27" Date

Scenario: Post Payment of min due + $30
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"AmountOfTotalDue+30" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

#Scenario: Post purchase and cash reversal
#  Given Post purchase reversal
#  Given Post cash reversal
#  Then Verify Transaction in DB