


--select top 10 * from commontnp with (nolock) order by trantime
--select * from ErrorTNP with (nolock) where acctid = 2281174 order by trantime

begin transaction

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (44896510810,44896423444,44896519154)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (44896510810,44896423444,44896519154)

--commit transaction
--rollback