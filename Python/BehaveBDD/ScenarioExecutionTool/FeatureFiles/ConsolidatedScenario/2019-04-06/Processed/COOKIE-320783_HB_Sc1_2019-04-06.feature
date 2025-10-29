Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_6
  Given execute Post payment_6 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 7
  Given execute Post purchase_7 of $500 by trancode 4005
