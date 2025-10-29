Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"
  
Scenario: Post Payment_1
  Given execute Post payment_1 of $SRBWithInstallmentDue by trancode 2102
  
  
Scenario: Post purchase 2
  Given execute Post purchase_2 of $500 by trancode 4005
