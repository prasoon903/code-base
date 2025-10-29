Feature: Plan payment example v12

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2018-05-23" Date

Scenario: Create Account With BillingCycle 31
    Given Create Account
        |JsonTag    |Value      |
        |ProductID  |7131       |
        |StoreName  |CookieStore  |
        |BillingCycle | 31 |
        |CreditLimit | 10000 |
    Then Verify Account Number in Database
    And Save tag into variable "AccountCreation"
    Then Wait for 10 seconds

Scenario: Post purchase and retail Transaction
  Given execute Post purchase_1 of $1000 by trancode 4005
  Then Wait for 60 seconds
  Given execute Post retailpurchase_1 of $1200 by trancode F4005 on CPM 13776
  Then Wait for 60 seconds
  Given execute Post retailpurchase_2 of $1300 by trancode F4005 on CPM 13776
  Then Wait for 60 seconds
  Given execute Post retailpurchase_3 of $1400 by trancode F4005 on CPM 13776
  

