

select bsacctid,accountnumber,tranid,transactionamount,trantime,posttime,txnsource,transactiondescription,postingref, datediff(month,trantime,posttime) DIFFCycle
into #pmt
From ccard_primary cp with(nolock) 
join trans_in_acct tia on tia.tran_id_index = cp.tranid
where cmttrantype = '21' and posttime > '2021-12-31 23:59:57.000' and tia.atid = 51
and datediff(month,trantime,posttime) > 0 --30155

select * From #pmt where bsacctid is null

select revtgt 
into #rev
From ccard_primary with(nolock) where revtgt in (select tranid from #pmt)

delete from #pmt where tranid in (select revtgt from #rev)

select sum(transactionamount) amt,bsacctid,month(trantime) mo 
into #byMO 
from #pmt group by bsacctid,month(trantime)

select * from #byMO--26641

update #pmt set transactionamount = amt from #pmt p join #byMO b on b.bsacctid = p.bsacctid and b.mo = month(p.trantime)

select row_number() over (partition by bsacctid,month(trantime) order by bsacctid,month(trantime)) RN,* 
into #Pmt1
from #pmt

select * 
into #Pmtfinal
From #Pmt1 
where rn = 1

--select * from #byMO where bsacctid = 44395 order by bsacctid


--drop table #stmt
selecT p.*,acctid,statementdate,chargeoffdate,cycleduedtd,ccinhparent125aid,systemstatus,currentbalance,amountoftotaldue,AmtOfPayCurrDue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,
AmountOfPayment90DLate,AmountOfPayment120DLate,AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate
intO #stmt
from STATEMentHEADER sh with(nolock) 
join #Pmtfinal p on p.bsacctid = sh.acctid
WHERE sh.statementdate > p.trantime

select * 
into #stmt30DPD 
from #stmt where cycleduedtd > 2 and statementdate < posttime order by acctid,statementdate

select b.tranid,b.acctid
into #phpTID
from #stmt30dpd s join LS_P1MARPRODDB01.CCgs_corEisSUE.DBO.bscbrphphistory b with(nolock) on b.acctid = s.bsacctid

update #stmt30DPD set accountnumber = 'DD' where tranid in (select tranid from #phpTID)

select bsacctid,transactionamount,trantime,posttime,statementdate,currentbalance,cycleduedtd,amountoftotaldue,AmtOfPayCurrDue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,
AmountOfPayment90DLate,AmountOfPayment120DLate,AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate,* 
from #stmt30DPD s where cycleduedtd > 2 and statementdate < posttime and systemstatus <> 14 and accountnumber <> 'DD'
order by acctid,s.statementdate

select * From #pmt where bsacctid = 198617

--drop table #temp30dpd
select * into 
#temp30dpd 
from #stmt30DPD

select bsacctid,transactionamount,trantime,posttime,statementdate,currentbalance,cycleduedtd,amountoftotaldue,AmtOfPayCurrDue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,
AmountOfPayment90DLate,AmountOfPayment120DLate,AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate,* 
from #temp30dpd s where cycleduedtd > 2 and statementdate < posttime and systemstatus <> 14 and accountnumber <> 'DD'
order by s.statementdate desc

select count(1) cnt,bsacctid into #multi From #temp30dpd group by bsacctid having count(1) > 1

delete from #temp30dpd where bsacctid in (select bsacctid from #multi)

SELECT * FROM #temp30dpd
/*
update t set t.AmountOfPayment210DLate = case when t.AmountOfPayment210DLate > 0 and t.AmountOfPayment210DLate <= t.transactionamount then t.AmountOfPayment210DLate * -1 else t.AmountOfPayment210DLate end
from #temp30dpd t
update t set t.AmountOfPayment180DLate = case when t.AmountOfPayment180DLate > 0 and t.AmountOfPayment210DLate <= 0 and  t.AmountOfPayment180DLate <= t.transactionamount + t.AmountOfPayment210DLate
then t.AmountOfPayment180DLate * -1 else t.AmountOfPayment180DLate end
from #temp30dpd t
update t set t.AmountOfPayment150DLate = case when t.AmountOfPayment150DLate > 0 and t.AmountOfPayment180DLate <= 0 and  t.AmountOfPayment150DLate <= t.transactionamount + t.AmountOfPayment210DLate
+ t.AmountOfPayment180DLate
then t.AmountOfPayment150DLate * -1 else t.AmountOfPayment150DLate end
from #temp30dpd t
update t set t.AmountOfPayment120DLate = case when t.AmountOfPayment120DLate > 0 and t.AmountOfPayment150DLate <= 0 and  t.AmountOfPayment120DLate <= t.transactionamount + t.AmountOfPayment210DLate
+ t.AmountOfPayment180DLate + t.AmountOfPayment150DLate
then t.AmountOfPayment120DLate * -1 else t.AmountOfPayment120DLate end
from #temp30dpd t
update t set t.AmountOfPayment90DLate = case when t.AmountOfPayment90DLate > 0 and t.AmountOfPayment120DLate <= 0 and  t.AmountOfPayment90DLate <= t.transactionamount + t.AmountOfPayment210DLate
+ t.AmountOfPayment180DLate + t.AmountOfPayment150DLate + t.AmountOfPayment120DLate
then t.AmountOfPayment90DLate * -1 else t.AmountOfPayment90DLate end
from #temp30dpd t
update t set t.AmountOfPayment60DLate = case when t.AmountOfPayment60DLate > 0 and t.AmountOfPayment90DLate <= 0 and  t.AmountOfPayment60DLate <= t.transactionamount + t.AmountOfPayment210DLate
+ t.AmountOfPayment180DLate + t.AmountOfPayment150DLate + t.AmountOfPayment120DLate + t.AmountOfPayment90DLate
then t.AmountOfPayment60DLate * -1 else t.AmountOfPayment60DLate end
from #temp30dpd t
update t set t.AmountOfPayment30DLate = case when t.AmountOfPayment30DLate > 0 and t.AmountOfPayment60DLate <= 0 and  t.AmountOfPayment30DLate <= t.transactionamount + t.AmountOfPayment210DLate
+ t.AmountOfPayment180DLate + t.AmountOfPayment150DLate + t.AmountOfPayment120DLate + t.AmountOfPayment90DLate + t.AmountOfPayment60DLate
then t.AmountOfPayment30DLate * -1 else t.AmountOfPayment30DLate end
from #temp30dpd t

select * From #temp30dpd where AmountOfPayment210DLate < 0
and accountnumber <> 'DD'
select * From #temp30dpd where AmountOfPayment180DLate < 0
and accountnumber <> 'DD'
select * From #temp30dpd where AmountOfPayment150DLate < 0
and accountnumber <> 'DD' and isnull(chargeoffdate,getdate()) > trantime
select * From #temp30dpd where AmountOfPayment120DLate < 0
and accountnumber <> 'DD' and isnull(chargeoffdate,getdate()) > trantime
select * From #temp30dpd where AmountOfPayment90DLate < 0
and accountnumber <> 'DD' and isnull(chargeoffdate,getdate()) > trantime
select * From #temp30dpd where AmountOfPayment60DLate < 0
and accountnumber <> 'DD' and isnull(chargeoffdate,getdate()) > trantime
select * From #temp30dpd where AmountOfPayment30DLate < 0
and accountnumber <> 'DD' and isnull(chargeoffdate,getdate()) > trantime
*/

select * From #temp30dpd where AmountOfPayment30DLate < 0
and accountnumber <> 'DD' and isnull(chargeoffdate,getdate()) > trantime


select * From #temp30dpd where accountnumber <> 'DD' ORDER BY BSAccTid

DROP TABLE IF EXISTS #TempCompute
SELECT *
INTO #TempCompute
FROM #temp30dpd
where accountnumber <> 'DD'

DROP TABLE IF EXISTS #TempComputedData
SELECT * ,
CASE	WHEN AmountOfPayment210DLate > TransactionAmount THEN 9
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate > TransactionAmount THEN 8
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate > TransactionAmount THEN 7
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate > TransactionAmount THEN 6
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate > TransactionAmount THEN 5
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate > TransactionAmount THEN 4
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate > TransactionAmount THEN 3
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate+AmtOfPayXDLate > TransactionAmount THEN 2
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate+AmtOfPayXDLate+AmtOfPayCurrDue > TransactionAmount THEN 1
		ELSE 0
		END
		AS ComputedCycleDueDTD
INTO #TempComputedData
FROM #TempCompute


SELECT * FROM #TempComputedData WHERE CycleDueDTD > ComputedCycleDueDTD AND (ChargeOffDate >= TranTime OR ChargeOffDate IS NULL)

select bsacctid,transactionamount,trantime,posttime,statementdate,currentbalance,cycleduedtd,amountoftotaldue,AmtOfPayCurrDue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,
AmountOfPayment90DLate,AmountOfPayment120DLate,AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate,* 
from #temp30dpd s where AmountOfPayment30DLate < 0
and accountnumber <> 'DD' and isnull(chargeoffdate,getdate()) > trantime and currentbalance > transactionamount
and datediff(month,trantime,posttime) = 1
order by s.statementdate desc

select bsacctid,accountnumber,tranid,transactionamount,trantime,posttime,statementdate,currentbalance,cycleduedtd,amountoftotaldue,AmtOfPayCurrDue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,
AmountOfPayment90DLate,AmountOfPayment120DLate,AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate,* 
from #temp30dpd s where AmountOfPayment30DLate < 0
and accountnumber <> 'DD' and isnull(chargeoffdate,getdate()) > trantime and currentbalance > transactionamount
and datediff(month,trantime,posttime) > 1
order by s.statementdate desc





--select * From ccardlookup with(nolock) where lutid = 'asstplan' and lutcode = '16300'
--select * from astatusaccounts with(nolock)


select * fROM currentbalanceaUdiT witH(NOlock) WHERE aid in (select acctid from #stMT) AND businesSday = '2022-10-31 23:59:57.000'
and dENAMe in ('115', '200' ) OrDER by AId

select paymENtHistprOfiLE,Acctid,statEMENTdate,accoUntstATus 
into #cBr
from LS_P1MARPRODDB01.CCgs_corEisSUE.DBO.cbreportingdetAIl with(nolock) 
wHERE aCcTid in (seleCt AcCtiD FROM #STmt) and sTatementdate = '2022-11-30 23:59:57.000' 

select * from #cbr where 

select bsacctid,accountnumber,tranid,transactionamount,trantime,posttime
into #pmt
From ccard_primary with(nolock) where cmttrantype = '21' and posttime < '2022-11-30 23:59:57.000' and posttime > '2022-10-31 23:59:57.000'
and datediff(month,trantime,posttime) = 1

select revtgt 
into #rev
From ccard_primary with(nolock) where revtgt in (select tranid from #pmt)

delete from #pmt where tranid in (select revtgt from #rev)


selecT aCctId,cycLeduedtd,STATEMENTDATE
intO #stMT
from STATEMentHEADER with(nolock) WHERE Acctid IN (select bsacctid from #pmt)
and sTatementdate = '2022-10-31 23:59:57.000' AND cYclEduedtd > 2 ANd sySTEmstatUS <> 14

select * fROM currentbalanceaUdiT witH(NOlock) WHERE aid in (select acctid from #stMT) AND businesSday = '2022-10-31 23:59:57.000'
and dENAMe in ('115', '200' ) OrDER by AId

select paymENtHistprOfiLE,* from LS_P1MARPRODDB01.CCgs_corEisSUE.DBO.cbreportingdetAIl with(nolock) wHERE aCcTid in (seleCt AcCtiD FROM #STmt) and sTatementdate = '2022-11-30 23:59:57.000' 
anD suBstriNg(paymenTHIstpROfile,0,1) = '1'

select * from #cbR where suBstriNg(paymenTHIstpROfile,1,1) = '1'

--select * from sys.serVers