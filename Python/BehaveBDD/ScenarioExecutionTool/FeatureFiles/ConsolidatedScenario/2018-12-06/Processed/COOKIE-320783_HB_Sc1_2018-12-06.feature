Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_2
  Given execute Post payment_2 of $SRBWithInstallmentDue by trancode 2102
 

Scenario: Post purchase 3
  Given execute Post purchase_3 of $500 by trancode 4005
