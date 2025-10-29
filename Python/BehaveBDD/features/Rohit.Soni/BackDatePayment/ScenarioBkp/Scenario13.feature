#1.01/02/2021  Post Transaction Purchase/Cash/BT
#2.13/02/2021 Age till 1st statement
#3.15/02/2021 Post Payment to total min due
#4.15/02/2021 Post 2nd Cash Transaction $160
#5.13/03/2021 Age till 2nd statement
#6.20/03/2021 Post Payment to total min due
#7.20/03/2021 Post 3rd Cash Transaction $50
#8.13/04/2021 Age till 3rd statement
#9.19/04/2021 Post Payment to total min due
#10.10/05/2021 Initiate Full Dispute of 1st Cash Transaction
#11.10/05/2021 Initiate Partial Dispute of 2nd Cash Transaction


Feature: Scenario 13

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-02-01" Date

Scenario: Create Account With BillingCycle 12
  Given Create Account
      |JsonTag    |Value      |
      |ProductID  |7131       |
      |StoreName  |JazzStore  |
      |BillingCycle | 12 |
      |CreditLimit | 10000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post purchase 1 and Cash purchase 1
  Given Post purchase of $"1000" by trancode "4005"
  Given Post cash purchase of $"500" by trancode "3001" and "13748"
  Given Post cash purchase of $"800" by trancode "4005" and "13746"
  Then Verify Transaction in DB

Scenario: Age system to "2021-02-13" Date
  Then  Age system to "2021-02-13" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-02-15" Date
  Then  Age system to "2021-02-15" Date

Scenario: Post payment of Due and cash purchase 2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB
  Given Post cash purchase of $"160" by trancode "3001" and "13748"
  Then Verify Transaction in DB

Scenario: Age system to "2021-03-13" Date
  Then  Age system to "2021-03-13" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-03-20" Date
  Then  Age system to "2021-03-20" Date

Scenario: Post payment of Due and cash purchase 3
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"2" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB
  Given Post cash purchase of $"50" by trancode "3001" and "13748"
  Then Verify Transaction in DB

Scenario: Age system to "2021-04-13" Date
  Then  Age system to "2021-04-13" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-04-19" Date
  Then  Age system to "2021-04-19" Date

Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"3" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Initiate dispute