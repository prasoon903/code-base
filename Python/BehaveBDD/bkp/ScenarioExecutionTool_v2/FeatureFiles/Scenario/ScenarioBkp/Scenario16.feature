Feature: Scenario 16

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-02-02" Date

Scenario: Create Account With BillingCycle 12
  Given Create Account
      |JsonTag    |Value      |
      |ProductID  |7131       |
      |StoreName  |JazzStore  |
      |BillingCycle | 12 |
      |CreditLimit | 10000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post Purchase Transaction
  Given execute Post purchase_1 of $800 by trancode 4005
  Then Wait for "60" seconds
  Given execute Post purchase_2 of $1200 by trancode 4005
  Then Wait for "60" seconds
  Given execute Post purchase_3 of $700 by trancode 4005
  Then Verify Transaction in DB

Scenario: Age system statement-1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-02-13" Date

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-02-20" Date

Scenario: Post Purchase return
  Given execute Post purchase return of $700 by trancode 4103
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-02-22" Date

Scenario: Post Purchase Transaction
  Given execute Post purchase_4 of $500 by trancode 4005
  Then Verify Transaction in DB

Scenario: Age system statement-2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-03-13" Date

Scenario: Age system statement-3
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-13" Date

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-27" Date

#Scenario: Post dispute
#  Given execute Post dispute of $1200
#  Given execute Post dispute of $500
#  Then Verify Transaction in DB