Feature: Scenario 18

Feature: Scenario 18


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
