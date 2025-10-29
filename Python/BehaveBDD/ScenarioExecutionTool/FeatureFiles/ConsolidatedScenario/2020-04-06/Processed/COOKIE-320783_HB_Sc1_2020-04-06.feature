Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_19
  Given execute Post payment_19 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 20
  Given execute Post purchase_20 of $500 by trancode 4005
