Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_13
  Given execute Post payment_13 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 14 
  Given execute Post purchase_14 of $500 by trancode 4005
