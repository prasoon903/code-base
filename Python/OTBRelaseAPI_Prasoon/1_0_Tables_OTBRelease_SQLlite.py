import sqlite3
import os

from SetUp import SetUp
obj_Setup=SetUp()

def py_Connect_SQLLite():
    conn = sqlite3.connect(obj_Setup.SQLLiteOTBDBPath+"\\OTBReleaseFile_DB.db")
    return  conn 

vr_conn=py_Connect_SQLLite()
vr_crsr=vr_conn.cursor()


OTBReleaseDetails_Table ='''
CREATE TABLE OTBReleaseDetails_sqllite (
Identity	INTEGER PRIMARY KEY	,
Label VARCHAR(100),
CreatedDate Datetime,
DisputeAmount Currency,
AcknowledgementDate varchar(100),
ProvCreditDate varchar(100),
RegZFinalDate varchar(100),
DisputeStatus Varchar(10),
ID varchar(50),
Fraudindicator INTEGER,
LineNumber INTEGER,
FileName VARCHAR(300),
TimeStamp Datetime);'''


OTBReleaseFiles_Table ='''
Create table OTBReleaseFiles_sqllite(
Identity INTEGER PRIMARY KEY,
FileNames VARCHAR(300),
TimeStmps DATETIME ,
TotalRecords INT,
Status Varchar(20));'''

OTBRelease_Log_table ='''
Create table OTBRelease_Log_sqllite(
Identity INTEGER PRIMARY KEY,
FileNames VARCHAR(300),
TimeStmps DATETIME ,
ErrorMessage VARCHAR(100),
ErrorLine INT,
ErrorFound VARCHAR(20));'''

try:
    vr_crsr.execute("Drop table OTBReleaseDetails_sqllite")
except:
    pass

try:
    vr_crsr.execute("Drop table OTBReleaseFiles_sqllite")
except:
    pass

try:
    vr_crsr.execute("Drop table OTBRelease_Log_sqllite")
except:
    pass

vr_crsr.execute(OTBReleaseDetails_Table)
vr_crsr.execute(OTBReleaseFiles_Table)
vr_crsr.execute(OTBRelease_Log_table)

#cursor.execute(sql_command)


print("\n\r*************************TABLES CREATED SUCCESSFULLY*********************************")

vr_conn.commit()

vr_conn.close()