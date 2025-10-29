Feature: Chargeoff

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2018-02-08" Date

Scenario: Create Account With BillingCycle 31
    Given Create Account
        |JsonTag    |Value      |
        |ProductID  |7131       |
        |StoreName  |CookieStore  |
        |BillingCycle | 31 |
        |CreditLimit | 10000 |
    Then Verify Account Number in Database
    And Save tag into variable "AccountCreation"
      And Age system to "2018-02-09" Date

Scenario: Post purchase and age till charge off
  Given execute Post purchase_1 of $1000 by trancode 4005
  Given execute Post retailpurchase_1 of $1200 by trancode F4005 on CPM 13776
  Given execute Post return_1 of $500 by trancode 4103
  Then  Age system to "2018-10-10" Date


    
