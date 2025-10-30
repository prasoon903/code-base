use master
exec SP_RestoreDb 'PARASHAR_TEST','\\Abrai4\D\DBBackup\15.00.02.03\78116\Final-01Sep2018_CI.bak'
use PARASHAR_TEST

use master
exec SP_RestoreDb 'PRASOON_CB_CC','\\XEON-S8\Labels\BANKCARD\CreditProcessing\Labels\CreditProcessing_15.00.02.03\Application\DB\1NewShrunk\CC.bak'
use PRASOON_CB_CC


use master
exec SP_RestoreDb 'PRASOON_CB_CoreCredit','\\XEON-S8\Labels\BANKCARD\CreditProcessing\Labels\CreditProcessing_15.00.02.03\Application\DB\1NewShrunk\CoreCredit.bak'
use PRASOON_CB_CoreCredit

use master
exec SP_RestoreDb 'PRASOON_CB_CoreApp','\\XEON-S8\Labels\BANKCARD\CreditProcessing\Labels\CreditProcessing_15.00.02.03\Application\DB\1NewShrunk\CoreApp.bak'
use PRASOON_CB_CoreApp


use master
exec SP_RestoreDb 'PRASOON_CB_CI','\\XEON-S8\Labels\BANKCARD\CreditProcessing\Labels\CreditProcessing_15.00.02.03\Application\DB\1NewShrunk\CI.bak'
use PRASOON_CB_CI


use master
exec SP_RestoreDb 'PRASOON_CB_CL','\\XEON-S8\Labels\BANKCARD\CreditProcessing\Labels\CreditProcessing_15.00.02.03\Application\DB\1NewShrunk\CL.bak'
use PRASOON_CB_CL


use master
exec SP_RestoreDb 'PRASOON_CB_CAuth','\\XEON-S8\Labels\BANKCARD\CreditProcessing\Labels\CreditProcessing_15.00.02.03\Application\DB\1NewShrunk\CAuth.bak'
use PRASOON_CB_CAuth