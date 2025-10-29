Feature: Scenario1(Test Case - Scenario1 Disable Posting 2.1) v2

Background:
  Given Run as "rerun"

Scenario: Test Given
  Given Test Given
  Then Age system to "2018-02-07" Dates

#Scenario: Create Account With BillingCycle 31
#  Given Create Account
#    |JsonTag    |Value      |
#    |ProductID  |7131       |
#    |StoreName  |CookieStore  |
#    |CreditLimit | 10000 |
#  Then Verify Account Number in Database
#  And Save tag into variable "AccountCreation"


Scenario: Post purchase 1
  Given execute Post purchase_2 of $16.50 by trancode 4005

#Scenario: Post dispute 1 of purchase 1
#  Given execute Post dispute_1 of $16.50 for purchase_1

#Scenario: Statement1
#  Given Test Given
#  Then Age system to "2018-04-10" Dates
#
#Scenario: Post payment
#  Given Get AccountSummary
#  Then Save tag into variable "AccountSummary"
#  Given execute Post payment of $29 by trancode 2102
#  Then  Age system to "2018-04-14" Date
#
#Scenario: Post credit return
#  Given execute Post return_1 of $100 by trancode 4103
#  Then  Age system to "2021-08-15" Date
		