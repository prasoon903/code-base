Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_5
  Given execute Post payment_5 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 6
  Given execute Post purchase_6 of $500 by trancode 4005
