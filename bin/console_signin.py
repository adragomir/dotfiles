#!/usr/bin/env python
import requests
import sys, os, urllib, json, webbrowser
from boto.sts import STSConnection
if len(sys.argv) == 3:
    account_id_from_user = sys.argv[1]
    role_name_from_user = sys.argv[2]
else:
    print "\n\tUsage: ",
    print os.path.basename(sys.argv[0]), # script name
    print " <account_id> <role_name>"
    exit(0)

# Create an ARN out of the information provided by the user.
role_arn = "arn:aws:iam::" + account_id_from_user + ":role/"
role_arn += role_name_from_user

# Step 2: Connect to AWS STS and then call AssumeRole. This returns
# temporary security credentials.
sts_connection = STSConnection()
assumed_role_object = sts_connection.assume_role(
    role_arn=role_arn,
    role_session_name="AssumeRoleSession"
)

# Step 3: Format resulting temporary credentials into a JSON block using
# known field names.
access_key = assumed_role_object.credentials.access_key
session_key = assumed_role_object.credentials.secret_key
session_token = assumed_role_object.credentials.session_token
json_temp_credentials = '{'
json_temp_credentials += '"sessionId":"' + access_key + '",'
json_temp_credentials += '"sessionKey":"' + session_key + '",'
json_temp_credentials += '"sessionToken":"' + session_token + '"'
json_temp_credentials += '}'

# Step 4. Make a request to the AWS federation endpoint to get a sign-in
# token, passing parameters in the query string. The call requires an
# Action parameter ('getSigninToken') and a Session parameter (the
# JSON string that contains the temporary credentials that have
# been URL-encoded).
request_parameters = "?Action=getSigninToken"
request_parameters += "&Session="
request_parameters += urllib.quote_plus(json_temp_credentials)
request_url = "https://signin.aws.amazon.com/federation"
request_url += request_parameters
r = requests.get(request_url)

# Step 5. Get the return value from the federation endpoint--a
# JSON document that has a single element named 'SigninToken'.
sign_in_token = json.loads(r.text)["SigninToken"]

# Step 6: Create the URL that will let users sign in to the console using
# the sign-in token. This URL must be used within 15 minutes of when the
# sign-in token was issued.
request_parameters = "?Action=login"
request_parameters += "&Issuer="
request_parameters += "&Destination="
request_parameters += urllib.quote_plus("https://console.aws.amazon.com/")
request_parameters += "&SigninToken=" + sign_in_token
request_url = "https://signin.aws.amazon.com/federation"
request_url += request_parameters

# Step 7: Use the default browser to sign in to the console using the
# generated URL.
webbrowser.open(request_url)
