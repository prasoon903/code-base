Feature: Chargeoff reclass Charge off reversal

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2018-03-08" Date

Scenario: Create Account With BillingCycle 31
    Given Create Account
        |JsonTag    |Value      |
        |ProductID  |7131       |
        |StoreName  |CookieStore  |
        |BillingCycle | 31 |
        |CreditLimit | 10000 |
    Then Verify Account Number in Database
    And Save tag into variable "AccountCreation"
      And Age system to "2018-03-09" Date

Scenario: Post purchase and age till charge off
  Given execute Post purchase_1 of $1000 by trancode 4005
  Given execute Post retailpurchase_1 of $1200 by trancode F4005 on CPM 13776
  Given execute Post return_1 of $500 by trancode 4103
  Then  Age system to "2018-11-10" Date

Scenario: Post Payment_1
  Given execute Post payment_1 of $200 by trancode 2102
  Then  Age system to "2018-11-11" Date

Scenario: Post charge off reversal
  Given execute Post chargeoffreversal_1 of $currentbalanceco by trancode 5401
  Then  Age system to "2018-12-12" Date

Scenario: Add status
  Given execute Add AddManualStatus for 16022
  Then  Age system to "2019-01-12" Date

Scenario: remove status
  Given execute Add RemoveManualStatus for 16022
  Then  Age system to "2019-02-12" Date

Scenario: Add status
  Given execute Add AddManualStatus for 16010
  Then  Age system to "2019-02-20" Date


    
