class SetUp:
    POTBAWSEnvironment = 1
    POTBAWS_secret_name = "ses-smtp-secret"
    POTBAWS_region_name = "ap-south-1"
    POTBAWS_service_name = "secretsmanager"
    POTBSES_smtp_url = "email-smtp.ap-south-1.amazonaws.com"
    POTBAWSPort = 587