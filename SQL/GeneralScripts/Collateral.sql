
			INSERT INTO AcctUpdElementMapping (UserDEName,ATID,DEName,SendRestructure,CMTTRANTYPE) VALUES ('CollateralID',51,'deCIDCollateral_ID',0,NULL)
		

		IF NOT EXISTS ( SELECT TOP 1 1 FROM AcctUpdElementMapping WITH(NOLOCK) WHERE UserDEName = 'CollateralID' )
		BEGIN
			INSERT INTO AcctUpdElementMapping (UserDEName,ATID,DEName,SendRestructure,CMTTRANTYPE) VALUES ('CollateralID',51,'deCIDCollateral_ID',0,NULL)
		END

		IF EXISTS (SELECT  TOP 1 1 FROM  APIMessageMaster WITH(NOLOCK) WHERE ErrorCode = 'ERR03516') 
		EXEC USP_GenerateErrorCodeForAPIErrorMessage 'Group Name is already exist.',1,3,'Yes',NULL,NULL,NULL,'ERR03516','Group Name already exists.'
	--ERR03516

select  * from ClearingFiles
SELECT * FROM AcctUpdElementMapping WITH(NOLOCK) WHERE UserDEName = 'CollateralID'


select * from CreateCHJobs
--DELETE FROM CreateCHJobs
SELECT * from IncomingFileJobs

SELECT * from CPSCollateralInfo
--DELETE from CPSCollateralInfo WHERE SKey > 1

SELECT * FROM CPSgmentAccounts WHERE acctId = 101241
--DELETE FROM CPSCollateralInfo WHERE SKey = 7

select * from AcctUpdElementMapping

SELECT * FROM MassUpdateLog

SELECT CollateralID,* FROM BSegmentCreditCard WHERE acctId IN (167413,167414,167415,167416,167417,167418,167419,167420,167421,167422)

sp_help BSegmentCreditCard

INSERT INTO AcctUpdElementMapping (UserDEName,ATID,DEName,SendRestructure,CMTTRANTYPE)
VALUES ('CollateralID',51,'deCIDCollateral_ID',0,NULL)

--UPDATE AcctUpdElementMapping SET ATID = 51 WHERE sKey = 26

--DELETE FROM incomingfilejobs where fileid=2

insert into incomingfilejobs(FileId,Path_FileName,MQPath,FileStatus,Date_Received,FileSource) values (1,'D:\BankCard\MassUpdate\BulkCID.txt',null,'NEW',Getdate(),'CREATECHJOBUPD')
insert into incomingfilejobs(FileId,Path_FileName,MQPath,FileStatus,Date_Received,FileSource) values (2,'D:\BankCard\MassUpdate\CID_Incorrect.txt',null,'NEW',Getdate(),'CREATECHJOBUPD')