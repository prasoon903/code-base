select ccinhparent125aid,currentbalance,amountoftotaldue,* from mergeaccountjob m with(nolock)
 join bsegment_Primary b with(nolock) on(m.srcbsacctid=b.acctid)
 join bsegmentcreditcard bcc with(nolock) on (b.acctid=bcc.acctid)
where b.ccinhparent125aid=16324 and bcc.amountoftotaldue>0 and m.jobstatus='DONE'

/*
17078
454210
774617
874455
1487074
1865795
1963638
3874240
4429367
5036265
7550673
12846134
12941763
16558063
19500064
284425
572240
21921059
1008955
1046274
2022187
2157312
2237466
2775965
5250748
17916436
18305862
20277376
*/