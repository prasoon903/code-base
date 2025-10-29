class JSONSetUp:

    APIJSONRequestFileIN='E:\Python\APICalling\CCManualReage\Incoming_file'
    APIJSONRequestFileError='E:\Python\APICalling\CCManualReage\Error'
    APIJSONRequestFileOUT='E:\Python\APICalling\CCManualReage\Processed'
    APIJSONRequestFileLog='E:\Python\APICalling\CCManualReage\Log'

    api_url = 'http://xeon-web1/PrasoonP/PrasoonPManualReage.aspx'

    JSON_Parameter = {
        "Password":"Test123!",
        "UserID":"PlatCall",
        "APIVersion":"2.0",
        "Source":"plat"
        }

