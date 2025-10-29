Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Post Payment_25
  Given execute Post payment_24 of $SRBWithInstallmentDue by trancode 2102
