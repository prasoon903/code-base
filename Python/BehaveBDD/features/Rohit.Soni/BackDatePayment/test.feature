Feature: Scenario 6 and 20 combined

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-02-04" Date

#Feature: Scenario 6

Scenario: Create Account With BillingCycle 8
    Given Create Account
        |JsonTag    |Value      |
        |ProductID  |7131       |
        |StoreName  |JazzStore  |
        |BillingCycle | 8 |
        |CreditLimit | 5000 |
    Then Verify Account Number in Database
    And Save tag into variable "AccountCreation"

Scenario: Post purchase and Cash Transaction
    Given Post purchase of $"1000" by trancode "4005"
    Given Post cash purchase of $"500" by trancode "3001" and "13748"
    Then Verify Transaction in DB
    Given Get Account Plan Details

#Feature: Scenario 20

Scenario: Create Account With BillingCycle 12
  Given Create Account
      |JsonTag      |  Value     |
      |ProductID    |  7131      |
      |StoreName    |  JazzStore |
      |BillingCycle |  12        |
      |CreditLimit  |  10000     |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post Purchase cash and BT Transaction
  Given Post purchase of $"149" by trancode "4005"
  Given Post cash purchase of $"55" by trancode "4005" and "13746"
  Given Post cash purchase of $"50.38" by trancode "3001" and "13748"
  Then Verify Transaction in DB
  Given Get Account Plan Details