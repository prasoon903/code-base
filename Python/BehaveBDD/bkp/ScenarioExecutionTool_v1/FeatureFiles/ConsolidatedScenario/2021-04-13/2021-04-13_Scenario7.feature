 Feature: Scenario 7.

 Background:
   Given Run as "rerun"

  Scenario: Age system
    Given Test Given


  Scenario: Post across cycle back-dated payment
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"
    Given Post Payment_"1" of $"30" by trancode "2102" at "posttime"
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

#1.02/02/2021 Post Purchase transaction $5000
#2.13/02/2021 Age till 1st Statement
#3.01/03/2021 Post payment of $30 (Less than min due)
#4.13/03/2021 Age till 2nd statement
#5.13/04/2021 Age till 3rd statement
#6.After Fix
#7.27/04/2021 Post backdated Transaction (Datetim localtransaction 01032021)