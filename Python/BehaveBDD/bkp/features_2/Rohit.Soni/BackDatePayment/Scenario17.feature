#1.02/08/2020 Post Purchase Transaction $100.00
#Post Cash Transaction of $50.00
#Post BT transaction of $100.00
#2.04/08/2020 1st statement
#3.04/09/2020 2nd statement
#4.14/09/2020 Post Payment of less than amount due
#5.21/09/2020 Post Payment of remaining amount amount due
#6.04/10/2020 Post payment of amount greater than CB of BT Plan
#7.08/10/2020 Post Payment of SRB (Aaccount become nothing due)
#8.Update Billing Table
#11153 to account
#9.Post Purchase Transaction $ 50
#Post BT Transaction $29.50
#Post Cash Transaction $25
#10.Age till account become Charged Off (Till 08/06/2021 )
#11.09/06/2021 Post Payment of $150


Feature: Scenario 17

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2020-08-02" Date

Scenario: Create Account With BillingCycle 3
  Given Create Account
      |JsonTag      |  Value     |
      |ProductID    |  7131      |
      |StoreName    |  JazzStore |
      |BillingCycle |  3         |
      |CreditLimit  |  10000     |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post Purchase, cash and BT Transaction
  Given Post purchase of $"100" by trancode "4005"
  Given Post cash purchase of $"50" by trancode "3001" and "13748"
  Given Post cash purchase of $"100" by trancode "4005" and "13746"
  Then Verify Transaction in DB

Scenario: Age system to "2020-08-04" Date -- Statement-1
  Then  Age system to "2020-08-04" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2020-09-04" Date -- Statement-2
  Then  Age system to "2020-09-04" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2020-09-14" Date
  Then  Age system to "2020-09-14" Date

Scenario: Post payment of less than Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"AmountOfTotalDue-10" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system to "2020-09-21" Date
  Then  Age system to "2020-09-21" Date

Scenario: Post Payment of remaining amount amount due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"2" of $"10" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system to "2020-10-04" Date
  Then  Age system to "2020-10-04" Date

Scenario: Post payment of amount greater than CB of BT Plan

Scenario: Age system to "2020-10-08" Date
  Then  Age system to "2020-10-08" Date

Scenario: Post Payment of SRB
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"4" of $"StatementRemainingBalanceWithInstallmentDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Update billing table 11153 to account

Scenario: Post Purchase, cash and BT Transaction
  Given Post purchase of $"50" by trancode "4005"
  Given Post cash purchase of $"29.5" by trancode "4005" and "13746"
  Given Post cash purchase of $"25" by trancode "3001" and "13748"
  Then Verify Transaction in DB

Scenario: Age till account become Charged Off
  Then  Age system to "2021-06-08" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-06-09" Date
  Then  Age system to "2021-06-09" Date

Scenario: Post Payment of $150
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"5" of $"150" by trancode "2102" at "posttime"
  Then Verify Transaction in DB