import smtplib
import email.utils
from email.mime.text import MIMEText

def check_email_active(email_address):
    # Create a test message
    msg = MIMEText('This is a test message to check if the email address is active.')
    msg['To'] = email.utils.formataddr(('Recipient', email_address))
    msg['From'] = email.utils.formataddr(('Sender', 'prasoon.parashar@corecard.com'))
    msg['Subject'] = 'Test Email'

    # Try sending the email
    try:
        server = smtplib.SMTP('corecard-com.mail.protection.outlook.com')  # Replace with your SMTP server
        server.sendmail('prasoon.parashar@corecard.com', [email_address], msg.as_string())
        server.quit()
        print(f"Email sent to {email_address}. Check for a response.")
    except smtplib.SMTPException as e:
        print(f"Failed to send email to {email_address}: {e}")


if __name__ == "__main__":
    email_to_check = input("Enter the email address to check: ")
    check_email_active(email_to_check)
