
/*
--Author       : Neha Vishwakarma
--Review by    : Vishal Sharma
--Date         : 11/15/2021
--Description  : To Fill Manual_LoyaltyTransactionMessage table with complete data. 
--Purpose 	       :CT#75019 Generate Reward Transaction as per @batchcount
-- Exec Pr_CookLoyaltyTxnManually @ChunkSize,@LogicModule,@ActualTranCode,@ArSystemAcctID
*/


--step -- 1 ---- Cook Data
 Exec Pr_CookLoyaltyTxnManually 1000,'605','60502R',23


 Exec Pr_GenerateLoyaltyTxnManually 1000 --  @batchcount



 
