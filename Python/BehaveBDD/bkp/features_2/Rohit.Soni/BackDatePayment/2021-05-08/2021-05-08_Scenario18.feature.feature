Feature: Scenario 18

Feature: Scenario 18


Scenario: Post payment reversal of Payment 1
  Given Post Payment Reversal of Payment_"1"
  Then Verify Transaction in DB

Scenario: Post purchase transaction
  Given Post purchase of $"200" by trancode "4005"
  Then Verify Transaction in DB

Scenario: Age system to "2021-05-08" Date -- Statement-2
  Then  Age system to "2021-05-08" Date
