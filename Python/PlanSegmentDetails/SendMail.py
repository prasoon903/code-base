import smtplib
from SetUp import SetUp
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


def SendMail(EMailSubject, EmailBody):

    S1 = SetUp()
    eMailFrom = S1.MailFrom
    eMailTo = S1.MailTo
    SMTP_SERVER = S1.SMTP_SERVER
    SMTPPORT = S1.SMTPPORT

    Body = MIMEText(EmailBody, 'html')
    # self.Message = EmailBody
    # self.LogMessage()

    # msg = EmailMessage()
    msg = MIMEMultipart('alternative')
    msg['Subject'] = EMailSubject
    msg['From'] = eMailFrom
    msg['To'] = eMailTo
    msg.attach(Body)

    server = smtplib.SMTP(SMTP_SERVER, SMTPPORT)
    # server.sendmail(self.eMailFrom, self.eMailTo, message)
    Message = "Sending mail..."
    print(Message)
    server.send_message(msg)
    server.quit()


