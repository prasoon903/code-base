Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_18
  Given execute Post payment_18 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 19
  Given execute Post purchase_19 of $500 by trancode 4005
