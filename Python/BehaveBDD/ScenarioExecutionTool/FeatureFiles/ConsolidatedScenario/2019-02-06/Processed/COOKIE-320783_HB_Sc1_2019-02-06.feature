Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_4
  Given execute Post payment_4 of $SRBWithInstallmentDue by trancode 2102
  
  
Scenario: Post purchase 5
  Given execute Post purchase_5 of $500 by trancode 4005
