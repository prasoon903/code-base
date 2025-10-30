 SELECT* FROM CCardLookUp WHERE LUTid like '%round%'
  SELECT* FROM CCardLookUp WHERE LUTid='storename' and LutDescription like '%Deserve%'
  SELECT* FROM CCardLookUp WHERE LUTid='Trancode' AND LutCode = '02'

  SELECT * from MonetaryTxnControl where LogicModule IN ('02','48') AND GroupId = 78

 select * from ccardlookup with (nolock) where lutdescription like '%bill%'

 select BTAmount,PromoMinimumPaymentAmt,* from AControlAccounts WHERE acctId =6385

 SELECT * from BillingTableAccounts WHERE acctId = 6788
  
 select * from Logo_Primary WHERE parent02AID=3189