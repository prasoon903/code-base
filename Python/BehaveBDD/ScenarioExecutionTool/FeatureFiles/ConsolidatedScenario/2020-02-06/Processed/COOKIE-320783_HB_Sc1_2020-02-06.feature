Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_17
  Given execute Post payment_17 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 18
  Given execute Post purchase_18 of $500 by trancode 4005
