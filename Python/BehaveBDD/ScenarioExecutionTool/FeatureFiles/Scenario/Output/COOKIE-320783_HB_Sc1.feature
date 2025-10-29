Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2018-02-10" Date

Scenario: Create Account With BillingCycle 31
  Given Create Account
        |JsonTag    |Value      |
        |ProductID  |7139       |
        |StoreName  |Cookie-2Store  |
        |BillingCycle | 31 |
        |CreditLimit | 10000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"
  
  
Scenario: Age system 
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2018-10-06" Date  
  

Scenario: Post purchase 1
  Given execute Post purchase_1 of $500 by trancode 4005
  Then  Age system to "2018-11-06" Date
  
Scenario: Post Payment_1
  Given execute Post payment_1 of $SRBWithInstallmentDue by trancode 2102
  
  
Scenario: Post purchase 2
  Given execute Post purchase_2 of $500 by trancode 4005
  Then  Age system to "2018-12-06" Date

Scenario: Post Payment_2
  Given execute Post payment_2 of $SRBWithInstallmentDue by trancode 2102
 

Scenario: Post purchase 3
  Given execute Post purchase_3 of $500 by trancode 4005
  Then  Age system to "2019-01-06" Date

Scenario: Post Payment_3
  Given execute Post payment_3 of $SRBWithInstallmentDue by trancode 2102
  
  
Scenario: Post purchase 4
  Given execute Post purchase_4 of $500 by trancode 4005
  Then  Age system to "2019-02-06" Date

Scenario: Post Payment_4
  Given execute Post payment_4 of $SRBWithInstallmentDue by trancode 2102
  
  
Scenario: Post purchase 5
  Given execute Post purchase_5 of $500 by trancode 4005
  Then  Age system to "2019-03-06" Date

Scenario: Post Payment_5
  Given execute Post payment_5 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 6
  Given execute Post purchase_6 of $500 by trancode 4005
  Then  Age system to "2019-04-06" Date

Scenario: Post Payment_6
  Given execute Post payment_6 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 7
  Given execute Post purchase_7 of $500 by trancode 4005
  Then  Age system to "2019-05-06" Date

Scenario: Post Payment_8
  Given execute Post payment_8 of $SRBWithInstallmentDue by trancode 2102
  
  
Scenario: Post purchase 9
  Given execute Post purchase_9 of $500 by trancode 4005
  Then  Age system to "2019-06-06" Date

Scenario: Post Payment_9
  Given execute Post payment_9 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 10
  Given execute Post purchase_10 of $500 by trancode 4005
  Then  Age system to "2019-07-06" Date

Scenario: Post Payment_10
  Given execute Post payment_10 of $SRBWithInstallmentDue by trancode 2102
  
  
Scenario: Post purchase 11
  Given execute Post purchase_11 of $500 by trancode 4005
  Then  Age system to "2019-08-06" Date

Scenario: Post Payment_11
  Given execute Post payment_11 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 12
  Given execute Post purchase_12 of $500 by trancode 4005
  Then  Age system to "2019-09-06" Date

Scenario: Post Payment_12
  Given execute Post payment_12 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 13
  Given execute Post purchase_13 of $500 by trancode 4005
  Then  Age system to "2019-10-06" Date

Scenario: Post Payment_13
  Given execute Post payment_13 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 14 
  Given execute Post purchase_14 of $500 by trancode 4005
  Then  Age system to "2019-11-06" Date

Scenario: Post Payment_14
  Given execute Post payment_14 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 15
  Given execute Post purchase_15 of $500 by trancode 4005
  Then  Age system to "2019-12-06" Date

Scenario: Post Payment_15
  Given execute Post payment_15 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 16
  Given execute Post purchase_16 of $500 by trancode 4005
  Then  Age system to "2020-01-06" Date

Scenario: Post Payment_16
  Given execute Post payment_16 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 17
  Given execute Post purchase_17 of $500 by trancode 4005
  Then  Age system to "2020-02-06" Date

Scenario: Post Payment_17
  Given execute Post payment_17 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 18
  Given execute Post purchase_18 of $500 by trancode 4005
  Then  Age system to "2020-03-06" Date

Scenario: Post Payment_18
  Given execute Post payment_18 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 19
  Given execute Post purchase_19 of $500 by trancode 4005
  Then  Age system to "2020-04-06" Date

Scenario: Post Payment_19
  Given execute Post payment_19 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 20
  Given execute Post purchase_20 of $500 by trancode 4005
  Then  Age system to "2020-05-06" Date

Scenario: Post Payment_20
  Given execute Post payment_20 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 21
  Given execute Post purchase_21 of $500 by trancode 4005
  Then  Age system to "2020-06-06" Date

Scenario: Post Payment_21
  Given execute Post payment_21 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 22
  Given execute Post purchase_22 of $500 by trancode 4005
  Then  Age system to "2020-07-06" Date

Scenario: Post Payment_22
  Given execute Post payment_22 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 23
  Given execute Post purchase_23 of $500 by trancode 4005
  Then  Age system to "2020-08-06" Date

Scenario: Post Payment_23
  Given execute Post payment_23 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 24
  Given execute Post purchase_24 of $500 by trancode 4005
  Then  Age system to "2020-09-06" Date

Scenario: Post Payment_24
  Given execute Post payment_24 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 25
  Given execute Post purchase_25 of $500 by trancode 4005
  Then  Age system to "2020-10-06" Date

Scenario: Post Payment_25
  Given execute Post payment_24 of $SRBWithInstallmentDue by trancode 2102
  Then  Age system to "2020-10-07" Date
