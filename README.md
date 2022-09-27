# Scripts

## * aws_login_with_mfa

Automatically generates token from STS and updates `~/.aws/credentials` file.

### How to use:

Install JQ

```
sudo apt install -y jq
```

bash mfa_login.sh -u <aws_username> -t <mfa_code> -p <aws_profile_name/env_name>

```
Example:
bash mfa_login.sh -u rwenceslau -t 864915 -p delivery-team

# Testing
aws s3 ls --profile mfa
```

### Make sure your .aws/credentials file follow this template (especially profile names):

```
[delivery-team]
aws_access_key_id = ---
aws_secret_access_key = ---

[mfa]
aws_access_key_id = ---
aws_secret_access_key = ---
aws_session_token = ---

[mfa-stg]
aws_access_key_id = ---
aws_secret_access_key = ---
aws_session_token = ---
role_arn = arn:aws:iam::688411838365:role/lawnstarter-engineer-staging
source_profile = mfa

[mfa-prod]
aws_access_key_id = ---
aws_secret_access_key = ---
aws_session_token = ---
role_arn = arn:aws:iam::512078713017:role/lawnstarter-engineer-production
source_profile = mfa
```

