# Scripts

## * aws_login_with_mfa

Automatically generates token from STS and updates `~/.aws/credentials` file.

### How to use:

```
bash mfa_login.sh -u <aws_username> -t <mfa_code> -p <aws_profile_name/env_name>

# Testing
aws s3 ls --profile mfa
```


