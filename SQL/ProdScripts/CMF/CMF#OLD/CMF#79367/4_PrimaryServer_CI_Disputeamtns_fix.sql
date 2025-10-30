 -- 6. Update in DisputesAmtNS  in bsegment_secondary -- 1 row affected 
	 UPDATE BSeg SET BSeg.DisputesAmtNS = BSeg.DisputesAmtNS - 2001.00
	 FROM bsegment_secondary BSeg  where BSeg.acctid = 17316630 
	  and  BSeg.DisputesAmtNS > 0 
	  	 
	 UPDATE BCPA SET BCPA.DisputesAmtNS = BCPA.DisputesAmtNS - 2001.00
	 FROM SYN_CAuth_Bsegment_Primary BCPA  where (BCPA.acctid = 17316630) 
	  and BCPA.DisputesAmtNS > 0 

	 -- 7. Update in DisputesAmtNS  in CPSgmentAccounts -- 1 row affected 
	 Update CPS SET CPS.DisputesAmtNS = CPS.DisputesAmtNS - 2001.00
	 FROM CPSgmentAccounts CPS where CPS.parent02AID =  17316630 
	 and  CPS.DisputesAmtNS > 0 and CPS.Acctid = 52584213