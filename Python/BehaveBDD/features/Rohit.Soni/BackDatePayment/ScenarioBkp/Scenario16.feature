#1.02/02/2021 post-purchase of 800
#post-purchase of 1200
#post-purchase of 700
#2.13/02/2021 Age till 1st statement
#3.20/02/2021 Post Purchase return $700
#4.22/02/2021 Post Purchase transaction of $500
#5.13/03/2021 Age till 2nd statement
#6.13/04/2021 Age till 3rd statement
#7. 27/04/2021
#Post Dispute of $1200
#Post Dispute of $500

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
  Given Post purchase of $"800" by trancode "4005"
  Given Post purchase of $"1200" by trancode "4005"
  Given Post purchase of $"700" by trancode "4005"
  Then Verify Transaction in DB

Scenario: Age system to "2021-02-13" Date -- statement-1
  Then  Age system to "2021-02-13" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-02-20" Date
  Then  Age system to "2021-02-20" Date

Scenario: Post Purchase return
  Given Post purchase return of $"700" by trancode "4103"
  Then Verify Transaction in DB

Scenario: Age system to "2021-02-22" Date
  Then  Age system to "2021-02-22" Date

Scenario: Post Purchase Transaction
  Given Post purchase of $"500" by trancode "4005"
  Then Verify Transaction in DB

Scenario: Age system to "2021-03-13" Date -- statement-2
  Then  Age system to "2021-03-13" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-04-13" Date -- statement-3
  Then  Age system to "2021-04-13" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-04-27" Date
  Then  Age system to "2021-04-27" Date

Scenario: Post dispute
  Given Post dispute of $1200
  Given Post dispute of $500
  Then Verify Transaction in DB