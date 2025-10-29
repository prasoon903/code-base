Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_3
  Given execute Post payment_3 of $SRBWithInstallmentDue by trancode 2102
  
  
Scenario: Post purchase 4
  Given execute Post purchase_4 of $500 by trancode 4005
