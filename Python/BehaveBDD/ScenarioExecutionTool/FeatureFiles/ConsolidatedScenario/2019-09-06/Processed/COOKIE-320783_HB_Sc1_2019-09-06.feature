Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_12
  Given execute Post payment_12 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 13
  Given execute Post purchase_13 of $500 by trancode 4005
