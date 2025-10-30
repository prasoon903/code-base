--Cookie20623----Prasoon----Start
	IF EXISTS (SELECT TOP 1 1 FROM CPS_Environment WITH(NOLOCK) WHERE Environment_Name LIKE '%PLAT%')
		BEGIN
			IF NOT EXISTS ( SELECT TOP 1 1 FROM CCardLookUp WITH(NOLOCK) WHERE LUTid = 'ASCBRStatusGroup' AND LutCode = '10')
				BEGIN 
					INSERT Into CCardLookUp (LUTid,LutCode,LutDescription,LutLanguage,DisplayOrdr,Module) values ('ASCBRStatusGroup',10,'Disaster Recovery','dbb',0,'BC')
				END			
			UPDATE AStatusAccounts SET CBRStatusGroup = 10 WHERE parent01AID = 15996 OR parent01AID = 16000   -- Disaster recovery and Resticted Disaster Recovery.			
		END		
--Cookie20623----Prasoon----End