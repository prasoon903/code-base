Feature: COOKIE-266974_UC5

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2018-02-10" Date

Scenario: Create Account With BillingCycle 31
  Given Create Account
        |JsonTag    |Value      |
        |ProductID  |7131       |
        |StoreName  |CookieStore  |
        |BillingCycle | 31 |
        |CreditLimit | 10000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post purchase 
  Given execute Post purchase_1 of $1000 by trancode 4005
  Given execute Post retailpurchase_1 of $1200 by trancode F4005 on CPM 13776
  # Then  Age system to "2018-05-11" Date

Scenario: Age system Statement-1-3
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2018-05-01" Date

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2018-05-15" Date

Scenario: Post Payment_1
  Given execute Post payment_1 of $SRBWithInstallmentDue by trancode 2102
  Then  Age system to "2018-06-16" Date
  
Scenario: Age system Statement-4
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2018-06-01" Date
  
Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2018-06-15" Date
  
# Scenario: Post Payment_1
#   Given execute Post payment_1 of $SRBWithInstallmentDue by trancode 2102
#   Then  Age system to "2018-06-16" Date
  
Scenario: Age system Statement-5
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2018-07-01" Date
  
Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2018-07-02" Date
  
# Scenario: Post Payment_1 RIP
#   Given execute Post payment reversal of payment_1
#   Then  Age system to "2018-06-16" Date

Scenario: Age system Statement-6 to 29
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2020-07-01" Date

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2020-07-10" Date

Scenario: Post payment/GWC
  Given execute Post payment_2 of $SRBWithInstallmentDue by trancode 2102

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2020-07-15" Date

Scenario: Add dispute of purchase_1
  Given execute Post Dispute_1 of $1000 for purchase_1
  # Then Age system to "2020-07-15" Date

# Scenario: Call T-R API
#   Given Execute API

