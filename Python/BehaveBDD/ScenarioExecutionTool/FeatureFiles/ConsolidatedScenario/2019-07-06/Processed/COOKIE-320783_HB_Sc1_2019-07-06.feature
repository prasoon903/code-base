Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_10
  Given execute Post payment_10 of $SRBWithInstallmentDue by trancode 2102
  
  
Scenario: Post purchase 11
  Given execute Post purchase_11 of $500 by trancode 4005
