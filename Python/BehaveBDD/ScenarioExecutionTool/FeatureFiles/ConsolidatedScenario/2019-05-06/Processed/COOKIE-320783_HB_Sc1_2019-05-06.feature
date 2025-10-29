Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_8
  Given execute Post payment_8 of $SRBWithInstallmentDue by trancode 2102
  
  
Scenario: Post purchase 9
  Given execute Post purchase_9 of $500 by trancode 4005
