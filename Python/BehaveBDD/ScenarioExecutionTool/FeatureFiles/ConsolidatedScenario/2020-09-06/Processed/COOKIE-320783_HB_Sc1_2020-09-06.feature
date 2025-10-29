Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_24
  Given execute Post payment_24 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 25
  Given execute Post purchase_25 of $500 by trancode 4005
