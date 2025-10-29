from SetUp import SetUp as S1
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import smtplib
from GetAWSSecretKey import get_secret
import json


def SendMail(EmailSubject, EmailBody, MessageLogger):
    try:
        if S1.RetailAWSEnvironment == 0:
            MessageLogger.debug("Inside SendMail")
            Body = MIMEText(EmailBody, 'html')

            msg = MIMEMultipart('alternative')
            msg['Subject'] = EmailSubject
            msg['From'] = S1.MailFrom
            msg['To'] = S1.MailTo
            msg.attach(Body)

            server = smtplib.SMTP(S1.SMTP_SERVER, S1.SMTPPORT)
            # server.sendmail(self.eMailFrom, self.eMailTo, message)
            Message = "SENDING MAIL ..."
            MessageLogger.info(Message)
            server.send_message(msg)
            server.quit()
        elif S1.RetailAWSEnvironment == 1:
            MessageLogger.info("INSIDE AWS SES PROCESS")

            Body = MIMEText(EmailBody, 'html')
            msg = MIMEMultipart('alternative')
            msg['Subject'] = EmailSubject
            msg['From'] = S1.MailFrom
            msg['To'] = S1.MailTo
            msg.attach(Body)

            AWSSecretKeyStr = get_secret(MessageLogger)

            AWSSecretKey = json.loads(AWSSecretKeyStr)

            #MessageLogger.info("AWSSecretKey: ", AWSSecretKey)

            user        = AWSSecretKey.get("id")
            password    = AWSSecretKey.get("ses_smtp_password_v4")

            MessageLogger.info("user: " + user)
            MessageLogger.info("password: " + password)

            server = smtplib.SMTP(S1.RetailSES_smtp_url, S1.RetailAWSPort)
            server.set_debuglevel(1)
            server.ehlo()
            server.starttls()
            server.ehlo()
            server.login(user, password)
            MessageLogger.info("SENDING MAIL ...")
            server.send_message(msg)
            MessageLogger.info("MAIL SENT")

        else:
            MessageLogger.info("INVALID ENVIRONMENT")
    except Exception as e:
        Error = True
        MessageLogger.exception("Error in sending mail ")