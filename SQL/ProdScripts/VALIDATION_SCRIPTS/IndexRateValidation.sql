SELECT CL.LutDescription AS InterestPlanDesc, IT.IntRateType, CLI.LutDescription AS InterestType,
case when IT.IntRateType = 0 then isnull(IT.FixedRate1,0) else ISNULL(IT.VarInterestRate+ISNULL (IT.Variance1, 0 ), 0) end AS TotalInterest, IT.VarInterestRate ,Variance1 ,IT.FixedRate1--, IT.Variance1, IT.Variance2, iT.variance3
from InterestAccounts IT WITH (NOLOCK)
LEFT OUTER JOIN CCardLookUp CL WITH (NOLOCK) ON (TRY_CONVeRT(VARCHaR, IT.acctId) = CL.LUTCode AND CL.Lutid = 'interestPlan')
LEFT OUTER JOIN CCardLookUp CLI WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, IT.IntRateType) = CLi.LUTCode AND ClI.Lutid = 'IntRateType')
WHERe iT.IntRateType not in ('0', '4') and CL.lutDescription <> 'Template Record'
order by IT.IntRateType desc


SELECT * FROM InterestRateUpdateJob WITH (NOLOCK) ORDER BY DateEffective DESC