-- TO BE RUN ON PRIMARY SERVER COREIssue DATABASE

Begin Tran
--commit
--rollback


Update Top(1) Bsegment_Primary SET AmtOfDispRelFromOTB=0.00,MergeAmtOfDispRelFromOTB=0.00 where acctid=1668061
Update Top(3) Bsegment_Primary SET MergeAmtOfDispRelFromOTB=0.00 where acctid in(223643,2713543,14991214)
Update Top(1) Bsegment_Primary SET MergeDisputeAmtNS=0.00 where acctid=1980427

Update Top(1) Bsegment_Primary SET AmtOfDispRelFromOTB=AmtOfDispRelFromOTB+208.09,MergeAmtOfDispRelFromOTB=0.00 where acctid=372660

Update Top(1) Bsegment_Primary SET AmtOfDispRelFromOTB=AmtOfDispRelFromOTB+115.00,MergeAmtOfDispRelFromOTB=0.00 where acctid=490512

Update Top(1) Bsegment_Primary SET AmtOfDispRelFromOTB=AmtOfDispRelFromOTB+16.04,MergeAmtOfDispRelFromOTB=0.00 where acctid=634255

Update Top(1) Bsegment_Primary SET AmtOfDispRelFromOTB=AmtOfDispRelFromOTB+29.23,MergeAmtOfDispRelFromOTB=0.00 where acctid=949861

Update Top(1) Bsegment_Primary SET AmtOfDispRelFromOTB=AmtOfDispRelFromOTB+96.49,MergeAmtOfDispRelFromOTB=0.00 where acctid=1515698

Update Top(1) Bsegment_Primary SET AmtOfDispRelFromOTB=AmtOfDispRelFromOTB+144.19,MergeAmtOfDispRelFromOTB=0.00 where acctid=2387490

Update Top(1) Bsegment_Primary SET AmtOfDispRelFromOTB=AmtOfDispRelFromOTB+174.98,MergeAmtOfDispRelFromOTB=0.00 where acctid=3876360

Update Top(1) Bsegment_Primary SET AmtOfDispRelFromOTB=AmtOfDispRelFromOTB+135.08,MergeAmtOfDispRelFromOTB=0.00 where acctid=11506890

Update Top(1) Bsegment_Primary SET AmtOfDispRelFromOTB=AmtOfDispRelFromOTB+358.85,MergeAmtOfDispRelFromOTB=0.00 where acctid=17745885


Update Top(1) Bsegment_Primary SET AmtOfDispRelFromOTB=AmtOfDispRelFromOTB+0.99,MergeAmtOfDispRelFromOTB=0.00 where acctid=18078265

Update Top(1) Bsegment_Primary SET AmtOfDispRelFromOTB=AmtOfDispRelFromOTB+10.87,MergeAmtOfDispRelFromOTB=0.00 where acctid=18735750

Update Top(1) Bsegment_Primary SET MergeAmtOfDispRelFromOTB=0.00 where acctid=21168066

Update Top(1)  Bsegment_Primary SET AmtOfDispRelFromOTB=AmtOfDispRelFromOTB+712.58,MergeAmtOfDispRelFromOTB=0.00 where acctid=21529929

Update Top(1) Bsegment_Primary SET AmtOfDispRelFromOTB=AmtOfDispRelFromOTB+79.95,MergeAmtOfDispRelFromOTB=0.00 where acctid=21891915


update Top(1) bsegment_secondary set premergeclientid = '8ae20886-b4e9-4fcd-b404-5067330c276a' where acctid = 1968311


















