Feature: COOKIE-266974_UC12

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2018-04-03" Date

Scenario: Create Account With BillingCycle 31
  Given Create Account
        |JsonTag    |Value      |
        |ProductID  |7131       |
        |StoreName  |CookieStore  |
        |BillingCycle | 31 |
        |CreditLimit | 10000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

# Scenario: Post purchase 1
#   Given execute Post purchase_1 of $1000 by trancode 4005
  
# Scenario: Age system Statement-1
#   Given Get AccountSummary
#   Then Save tag into variable "AccountSummary"
#   Then  Age system to "2018-05-01" Date
  
# Scenario: Age system
#   Given Get AccountSummary
#   Then Save tag into variable "AccountSummary"
#   Then  Age system to "2018-04-05" Date
  
# Scenario: Post Payment_1
#   Given execute Post payment_1 of $CurrentBalance by trancode 2102
#   Then  Age system to "2018-04-20" Date

Scenario: Post purchase 2
  Given execute Post purchase_2 of $2000 by trancode 4005
  
Scenario: Age system Statement-1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2018-05-01" Date
  
Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2018-05-05" Date
  
Scenario: Post purchase 3
  Given execute Post purchase_3 of $2000 by trancode 4005

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2018-05-15" Date

Scenario: Post payment/GWC
  Given execute Post return_1 of $1500 by trancode 4102

Scenario: Age system Statement-2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2018-06-01" Date

Scenario: Post Payment_2
  Given execute Post payment_2 of $SRBWithInstallmentDue by trancode 2102


Scenario: Age system Statement-3 to 27
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2020-07-01" Date

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2020-07-15" Date
  

Scenario: Add dispute of purchase_1
  Given execute Post Dispute_1 of $1000 for purchase_1
  # Then Age system to "2020-07-15" Date

# Scenario: Call T-R API
#   Given Execute API

