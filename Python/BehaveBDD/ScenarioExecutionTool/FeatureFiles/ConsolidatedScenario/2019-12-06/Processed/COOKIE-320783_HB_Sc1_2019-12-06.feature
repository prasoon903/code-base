Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_15
  Given execute Post payment_15 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 16
  Given execute Post purchase_16 of $500 by trancode 4005
