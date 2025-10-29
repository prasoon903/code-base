#1. 02/03/2021 Post Promo Purchase Transaction $200 and Cash Transaction of $100
#2. 08/03/2021 age till 1st statement
#3.08/04/2021 age till 2nd statement
#4.27/04/2021 Post Purchase $100
#5.02/05/2021 post Payment
#6. 08/05/2021 Age till 3rd statement
#7.09/05/2021 Post Payment


Feature: Scenario 15.2

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

Scenario: Post Purchase Transaction $100
  Given Post purchase of $"1000" by trancode "4005"
  Then Verify Transaction in DB

Scenario: Age system to "2021-05-02" Date
  Then  Age system to "2021-05-02" Date

Scenario: Post Payment of min due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system to "2021-05-08" Date -- statement-3
  Then  Age system to "2021-05-08" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-05-09" Date
  Then  Age system to "2021-05-09" Date

Scenario: Post Payment of min due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"2" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB