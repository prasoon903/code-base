Feature: Enable posting2.0

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-05-16" Date

#Scenario: Create Account With BillingCycle 12
#  Given Create Account
#      |JsonTag    |Value      |
#      |ProductID  |7131       |
#      |StoreName  |JazzStore  |
#      |BillingCycle | 12 |
#      |CreditLimit | 10000 |
#  Then Verify Account Number in Database
#  And Save tag into variable "AccountCreation"
#
#Scenario: Post purchase 1
#  Given execute Post purchase_1 of $500 by trancode 4005
#  Then Age system to "2021-05-12" Date
#  # Then Verify Transaction in DB

Scenario: Post purchase 2
  Given Test Given
  Then Wait for 60 seconds
  When Enable Posting2.0
  Then Wait for 60 seconds
  When Disable Posting2.0
  Then Age system to "2021-05-17" Date

#  Scenario: Test Given
#    Given Test Given
#    Then Age system to "2020-08-24" Date

#Scenario: Add status and add dispute
##    Given execute Add AddManualStatus for 15996
#    Given execute Post Dispute_1 of $100 for cashpurchase_1
#    Then Age system to "2020-07-30" Date

#Scenario: Test Given
#    Given Test Given
#    Then Age system to "2020-08-24" Date

#Scenario: Dispute resolution
#  Given execute Post disputeresolution_1 of $50 for Dispute_1 with action 4
#  Then Age system to "2020-08-10" Date

#Scenario: Add and remove status
#  Given execute Add AddManualStatus for 15996
#  Given execute Add RemoveManualStatus for 15996
#  Then Age system to "2020-08-13" Date

#Scenario: Apply reage
##  Given execute add reageenrollment with $50 for 3 months
##  Given execute add tcapenrollment for 3 months
##  Given execute add pwpenrollment for 60 months
#  Given execute add AccountUpdate for BillingTable with 10370
#  Then Age system to "2020-08-25" Date