Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_20
  Given execute Post payment_20 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 21
  Given execute Post purchase_21 of $500 by trancode 4005
