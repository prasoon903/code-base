Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_21
  Given execute Post payment_21 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 22
  Given execute Post purchase_22 of $500 by trancode 4005
