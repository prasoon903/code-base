#1.02/04/2021 Post Transactions
#Purchase = $149.00
#BT = $55.00
#Cash = $50.38
#2.08/04/2021 Age till 1st statement
#3.After Fix
#4.27/04/2021 Post Payment of Amount Due
#5.02/05/2021 Post Purchase Return $149.00
#6. 03/05/2021 Post Payment reversal posted on 27/04/2021
# And Post purchase Transaction $200.00
#7.08/05/2021 age till 2nd statement
#8.09/05/2021 Post Payment of Amount Due
#9.10/05/2021 Post Over Payment
#10.08/06/2021 age till 3rd statement
#11.09/06/2021 Reverse the over payment
  
Feature: Scenario 18

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-04-02" Date

Scenario: Create Account With BillingCycle 7
  Given Create Account
      |JsonTag      |  Value     |
      |ProductID    |  7131      |
      |StoreName    |  JazzStore |
      |BillingCycle |  7         |
      |CreditLimit  |  10000     |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post Purchase, cash and BT Transaction
  Given Post purchase of $"149" by trancode "4005"
  Given Post cash purchase of $"50.38" by trancode "3001" and "13748"
  Given Post cash purchase of $"55" by trancode "4005" and "13746"
  Then Verify Transaction in DB
  
Scenario: Age system to "2021-04-08" Date -- Statement-1
  Then  Age system to "2021-04-08" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  
Scenario: Age system to "2021-04-27" Date
  Then  Age system to "2021-04-27" Date

Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system to "2021-05-02" Date
  Then  Age system to "2021-05-02" Date

Scenario: Post Purchase return
  Given Post purchase return of $"149" by trancode "4103"
  Then Verify Transaction in DB

Scenario: Age system to "2021-05-03" Date
  Then  Age system to "2021-05-03" Date

Scenario: Post payment reversal of Payment 1
  Given Post Payment Reversal of Payment_"1"
  Then Verify Transaction in DB

Scenario: Post purchase transaction
  Given Post purchase of $"200" by trancode "4005"
  Then Verify Transaction in DB

Scenario: Age system to "2021-05-08" Date -- Statement-2
  Then  Age system to "2021-05-08" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-05-09" Date
  Then  Age system to "2021-05-09" Date

Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"2" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system to "2021-05-10" Date
  Then  Age system to "2021-05-10" Date

Scenario: Post over-payment
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"3" of $"50" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system to "2021-06-08" Date -- Statement-2
  Then  Age system to "2021-06-08" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-06-09" Date
  Then  Age system to "2021-06-09" Date

Scenario: Post payment reversal of Payment 3
  Given Post Payment Reversal of Payment_"3"
  Then Verify Transaction in DB