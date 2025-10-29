Feature: Scenario for multiple retail paid off plans v15

  Background:
    Given Run as "rerun"

Scenario: Test Given
  Given Test Given
  Then Age system to "2018-02-22" Date

Scenario: Create Account With BillingCycle 31
  Given Create Account
      |JsonTag    |Value      |
      |ProductID  |7131       |
      |StoreName  |CookieStore  |
      |BillingCycle | 31 |
      |CreditLimit | 5000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Test Given
  Given Test Given
  Then Age system to "2018-02-23" Date

Scenario: Post purchase and retail purchase
  Given execute Post purchase_1 of $1000 by trancode 4005
  Then Wait for 60 seconds
  Given execute Post retailpurchase_1 of $120 by trancode F4005 on CPM 13776
  Then Wait for 60 seconds
  Given execute Post retailpurchase_2 of $120 by trancode F4005 on CPM 13776
  Then Wait for 60 seconds
  Given execute Post retailpurchase_3 of $120 by trancode F4005 on CPM 13776
  Then Wait for 60 seconds
  Given execute Post retailpurchase_4 of $120 by trancode F4005 on CPM 13776
  Then Wait for 60 seconds
  Given execute Post retailpurchase_5 of $120 by trancode F4005 on CPM 13776
  Then Wait for 60 seconds
  Given execute Post retailpurchase_6 of $120 by trancode F4005 on CPM 13776
  Then Wait for 60 seconds
  Given execute Post retailpurchase_7 of $120 by trancode F4005 on CPM 13776
  Then Wait for 60 seconds
  Given execute Post retailpurchase_8 of $120 by trancode F4005 on CPM 13776
  Then Wait for 60 seconds
  Given execute Post retailpurchase_9 of $120 by trancode F4005 on CPM 13776
  Then Wait for 60 seconds
  Given execute Post retailpurchase_10 of $120 by trancode F4005 on CPM 13776
  Then  Age system to "2018-03-01" Date
#    Given execute Get PlanSegmentDetails

Scenario: Post payment of min due and do statement2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_1 of $AmountOfTotalDue by trancode 2102
  Then  Age system to "2018-04-01" Date

Scenario: Post payment of min due and do statement2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_2 of $AmountOfTotalDue by trancode 2102
  Then  Age system to "2018-05-01" Date

Scenario: Post full payment
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_3 of $CurrentBalance by trancode 2102
  Then  Age system to "2018-05-02" Date

Scenario: Post purchase and 3 retail purchase and do statement1
  Given execute Post purchase_2 of $1000 by trancode 4005
  Then Wait for 60 seconds
  Given execute Post retailpurchase_11 of $120 by trancode F4005 on CPM 13776
  Then Wait for 60 seconds
  Given execute Post retailpurchase_12 of $120 by trancode F4005 on CPM 13776
  Then Wait for 60 seconds
  Given execute Post retailpurchase_13 of $120 by trancode F4005 on CPM 13776
  Then  Age system to "2018-05-03" Date

Scenario: PSD response before API Job process
  Given execute Get PlanSegmentDetails

Scenario: Start API JOB then call the PSD API
    Given Start APIJOB
    Then Wait for 60 seconds
    Given execute Get PlanSegmentDetails
    Given Stop APIJob
    Then  Age system to "2018-05-04" Date
