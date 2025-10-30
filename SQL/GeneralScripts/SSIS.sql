SELECT * FROM CCGS_RPT_CoreIssue..AccountInfoForReport WITH (NOLOCK)

--EXEC msdb.dbo.sp_start_job 'EODSSISJobProcessing'

--EXEC dbo.p_Get_LoyaltyInfoForReport_By_BusinessDay_InstitutionID
--EXEC dbo.p_Get_CustomerLoyaltyInfoForReport_By_BusinessDay_InstitutionID

SELECT PODID,* FROM CCGS_CoreIssue..AccountInfoForReport WITH (NOLOCK)

SELECT * FROM CCGS_CoreIssue..CustomerLoyaltyInfoForReport WITH (NOLOCK)
SELECT * FROM CCGS_RPT_CoreIssue..CustomerLoyaltyInfoForReport WITH (NOLOCK)

SELECT * FROM CCGS_CoreIssue..CustomerLoyaltyInfoForReport WITH (NOLOCK) WHERE Skey = 1561
SELECT * FROM CCGS_RPT_CoreIssue..LoyaltyInfoForReport WITH (NOLOCK)

SELECT * FROM CCGS_CoreIssue..EODControlData WITH (NOLOCK) WHERE InstitutionID = 6969 AND Skey = 16

SELECT * FROM PARASHAR_TEST..EODControlData WITH (NOLOCK)

SELECT * FROM CCGS_RPT_CoreIssue..EODControlData WITH (NOLOCK)

--TRUNCATE TABLE CCGS_RPT_CoreIssue..AccountInfoForReport
--TRUNCATE TABLE CCGS_RPT_CoreIssue..PlanInfoForReport
--TRUNCATE TABLE CCGS_RPT_CoreIssue..PlanInfoForAccount
--TRUNCATE TABLE CCGS_RPT_CoreIssue..LoyaltyInfoForReport
--TRUNCATE TABLE CCGS_RPT_CoreIssue..CustomerLoyaltyInfoForReport
--TRUNCATE TABLE CCGS_RPT_CoreIssue..EODControlData
--TRUNCATE TABLE CCGS_CoreIssue..t_dba_SSIS_Variables_EODControlData

--UPDATE CCGS_CoreIssue..EODControlData SET JobStatus = 'NEW' WHERE Skey = 16

--UPDATE CCGS_CoreIssue..EODControlData SET JobStatus = 'Completed'

SELECT * FROM APIMessageMaster WITH (NOLOCK) WHERE ErrorCode = 'ERR04364'

SELECT * FROM t_dba_SSIS_Variables_EODControlData

SELECT * FROM msdb.dbo.sysjobhistory

SELECT  info_value, [Info_Key]
FROM ADMIN.DBO.[tb_info] WHERE [Info_Key]='SSIS-Plat-EOD-Completion-Email-List'

select top 1 Environment_Name from cps_environment with(nolock)

EXEC dbo.p_dba_Show_EODControlData_Completed  
@SendMail=1
,@ToEmail= 'SSIS-Plat-EOD-Completion-Email-List'


