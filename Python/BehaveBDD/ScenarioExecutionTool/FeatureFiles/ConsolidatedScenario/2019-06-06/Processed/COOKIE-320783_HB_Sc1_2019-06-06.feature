Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_9
  Given execute Post payment_9 of $SRBWithInstallmentDue by trancode 2102
  
Scenario: Post purchase 10
  Given execute Post purchase_10 of $500 by trancode 4005
