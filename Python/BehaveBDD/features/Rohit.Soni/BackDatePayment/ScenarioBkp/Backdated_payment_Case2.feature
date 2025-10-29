Feature: Verify delinquency should not impact when two payments of same amount was made and
  one would get reversed on next cycle.Also verify the distribution after payment reversal.
  Background:
    Given Run as "new"

  Scenario: Test Given
      Given Test Given
      Then Age system to "2021-01-08" Date

  Scenario: Create Account With BillingCycle 8
      Given Create Account
          |JsonTag    |Value      |
          |ProductID  |7131       |
          |StoreName  |JazzStore  |
          |BillingCycle | 8 |
          |CreditLimit | 5000 |
      Then Verify Account Number in Database
      And Save tag into variable "AccountCreation"
      And Age system to "2021-04-04" Date

  Scenario: Post purchase and Cash Transaction
      Given Post purchase of $"285" by trancode "4005"
      Given Post cash purchase of $"300" by trancode "3001" and "13748"
      Then  Age system to "2021-04-13" Date

      Given Get AccountSummary
      Then Save tag into variable "AccountSummary"

  Scenario: Post payment of min due
      Given Post Payment_"1" of $"29" by trancode "2102" at "posttime"


  Scenario: Post payment of min due again
      Given Post Payment_"2" of $"29" by trancode "2108" at "posttime"
      Then Age system to "2021-05-10" Date

  Scenario: Post Payment-1 reversal
      Given Run as "rerun"
      Given Post Payment Reversal of "Payment_1"
      Then Verify Transaction in DB

      Given Get AccountSummary
          |JsonTag          |Value           |
          |AccountNumber    |@MyAccountnUmber|
      Then Save tag into variable "AccountSummary"
      And Age system to "2021-05-12" Date

  Scenario: Post Backdate Payment-1
      Given Post Payment_"3" of $"20" by trancode "2108" at "20210413151515"

      Given Get AccountSummary
          |JsonTag          |Value           |
          |AccountNumber    |@MyAccountnUmber|
      Then Save tag into variable "AccountSummary"

  Scenario: Post Payment-2 reversal
      Given Post Payment Reversal of "Payment_2"
      Then Verify Transaction in DB

      Given Get AccountSummary
          |JsonTag          |Value           |
          |AccountNumber    |@MyAccountnUmber|
      Then Save tag into variable "AccountSummary"

  Scenario: Post Backdate Payment-2
      Given Post Payment_"4" of $"29" by trancode "2108" at "20210413161515"
      Then Verify Transaction in DB

      Given Get AccountSummary
          |JsonTag          |Value           |
          |AccountNumber    |@MyAccountnUmber|
      Then Save tag into variable "AccountSummary"

  Scenario: Post Backdate Payment-1 Reversal
      Given Post Payment Reversal of "Payment_3"
      Then Verify Transaction in DB

     Given Get AccountSummary
          |JsonTag          |Value           |
          |AccountNumber    |@MyAccountnUmber|
     Then Save tag into variable "AccountSummary"

  Scenario: Post Backdate Payment-2 Reversal
      Given ost Payment Reversal of "Payment_4"
      Then Verify Transaction in DB