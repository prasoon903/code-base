Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_22
  Given execute Post payment_22 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 23
  Given execute Post purchase_23 of $500 by trancode 4005
