import urllib

from SetUp import SetUp
from ConnectDB import ConnectDB
from SendMail import SendMail
import datetime


class APIStatus:
    C1 = ConnectDB()
    S1 = SetUp()

    CI_DB = S1.CI_DB

    APICount = 0
    TookTime = 0
    TDate = str(datetime.datetime.now())

    EmailBody = "<b>Server Name: </b>" + S1.SERVERNAME + "<br>"
    EmailBody = EmailBody + "<b>Operating Time: </b>" + str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) \
                + "<br>" + "<br>" + "<br>"

    EmailBody = EmailBody + \
                "<table>" \
                "<tr>" \
                    "<td><b>APICount</b></td>" \
                    "<td><b>TookTime</b></td>" \
                "</tr>"

    EMailSubject = "Alert | PlanSegmentDetails API Call Summary"

    Query = "SELECT TOP 1 CONVERT(VARCHAR(50), tnpdate, 101) + ' ' + CONVERT(VARCHAR, GETDATE(), 108) AS TDate FROM "\
            + CI_DB + "..CommonTNP WITH (NOLOCK) WHERE ATID = 60"

    connection = C1.ConnectDB()
    Result = connection.execute(Query)
    Row = Result.fetchall()

    for r in Row:
        TDate = str(r.TDate)

    # TDate = urllib.quote("'" + TDate + "'")

    # print(TDate)

    query = ";WITH APITime \
            AS \
            ( \
                SELECT \
                CASE	WHEN APITookTime < 1 THEN \'0-1\' \
                            WHEN APITookTime >= 1 AND APITookTime < 2 THEN \'1-2\' \
                            WHEN APITookTime >= 2 AND APITookTime < 3 THEN \'2-3\' \
                            WHEN APITookTime >= 3 AND APITookTime < 4 THEN \'3-4\' \
                            WHEN APITookTime >= 4 AND APITookTime < 5 THEN \'4-5\' \
                            WHEN APITookTime >= 5 THEN \'5 or more\' \
                            ELSE \'NA\' \
                END \
                AS TookTime \
                FROM " + CI_DB + "..TCIVRRequest  WITH(NOLOCK) \
                WHERE RequestDate  > DATEADD(MINUTE, -180, '" + TDate + "') \
                AND RequestName = 113524 \
            ) \
            SELECT COUNT(1) AS APICount, TookTime \
            FROM APITime WITH (NOLOCK) \
            GROUP BY TookTime"
    # print(query)

    result = connection.execute(query)

    row = result.fetchall()
    rowCount = len(row)

    if rowCount > 0:
        for r in row:
            APICount = r.APICount
            TookTime = r.TookTime

            EmailBody = EmailBody + \
                        "<tr>" \
                            "<td style=""color:blue;""><b>" + str(APICount) + "<b></td>" \
                            "<td style=""color:green;"">" + str(TookTime) + "</td>" \
                        "</tr>"

    connection.close()
    EmailBody = EmailBody + "</table>"

    StyleBody = "<style>" \
                "table, th {" \
                "border: 2px solid black;" \
                "border-collapse: collapse;" \
                "}" \
                "td {" \
                "border: 1px solid black;" \
                "border-collapse: collapse;" \
                "}" \
                "</style>"
    EmailBody = StyleBody + "<html>" + EmailBody + "</html>"

    SM1 = SendMail(EMailSubject, EmailBody)
