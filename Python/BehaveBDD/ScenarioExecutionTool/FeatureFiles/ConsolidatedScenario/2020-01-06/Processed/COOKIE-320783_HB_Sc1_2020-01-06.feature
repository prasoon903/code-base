Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_16
  Given execute Post payment_16 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 17
  Given execute Post purchase_17 of $500 by trancode 4005
