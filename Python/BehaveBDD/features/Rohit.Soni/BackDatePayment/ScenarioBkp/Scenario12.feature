#1.25/01/2021 Post Transaction Purchase/Cash/BT
#2.04/02/2021 Age till 1st statement
#3.13/02/2021 Post Payment of min due
#4.04/03/2021 Age till 2nd statement
#5.13/03/2021 Post Payment of min due of second cycle
#6.04/04/2021 Age till 3rd statement
#AFTER FIX
#7.27/04/2021 Post Payment reversal posted on 13/02/2021
#8. Verify Ccard_primary and account summary api
#9.08/05/2021 Age till 4th statement
#10.27/04/2021 Post Payment reversal posted on 14/02/2021
#11. Verify Ccard_primary and account summary api

Feature: Scenario 12

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-01-25" Date

Scenario: Create Account With BillingCycle 3
  Given Create Account
      |JsonTag    |Value      |
      |ProductID  |7131       |
      |StoreName  |JazzStore  |
      |BillingCycle | 3 |
      |CreditLimit | 10000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post purchase and Cash Transaction
  Given Post purchase of $"1000" by trancode "4005"
  Given Post cash purchase of $"500" by trancode "3001" and "13748"
  Given Post cash purchase of $"800" by trancode "4005" and "13746"
  Then Verify Transaction in DB

Scenario: Age system to "2021-02-04" Date
  Then  Age system to "2021-02-04" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-02-13" Date
  Then  Age system to "2021-02-13" Date

Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system to "2021-03-04" Date
  Then  Age system to "2021-03-04" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-03-13" Date
  Then  Age system to "2021-03-13" Date

Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"2" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system to "2021-04-04" Date
  Then  Age system to "2021-04-04" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-04-27" Date
  Then  Age system to "2021-04-27" Date

Scenario: Post payment reversal of Payment 1
  Given Post Payment Reversal of Payment_"1"
  Then Verify Transaction in DB