#!/bin/bash

set -eu

usage() {
    cat <<- EOF
    $(basename $0)

  Required:
    -u    Username
    -t    Token code
    -p    AWS profile name
EOF
    exit ${1:-32}
}

missing_arg() {
    echo
    echo "${1} requires an argument."
    echo
    usage 33
}

validate_single() {
    if [ -z "$(eval echo \$$1)" ]; then
        echo
        echo "${@:3}"
        echo
        usage "$2"
    fi
}

validate() {
    for arg in "$@"; do
        validate_single ${arg} 34 "${arg} is a required parameter."
    done
}

while getopts ':u:t:p:h' opt; do
    case "${opt}" in
        u)
            USERNAME="${OPTARG}"
        ;;
        t)
            TOKEN="${OPTARG}"
        ;;
        p)
            AWS_PROFILE="${OPTARG}"
        ;;
        ?)
            usage
        ;;
        :)
            missing_arg "${OPTARG}"
        ;;
    esac
done

validate USERNAME TOKEN AWS_PROFILE

OUTPUT="$(aws sts get-session-token --serial-number arn:aws:iam::600756176935:mfa/$USERNAME --token-code $TOKEN --profile $AWS_PROFILE --duration-seconds 129600)"

ACCESS_KEY_ID=$(echo $OUTPUT | jq '.Credentials.AccessKeyId' | sed -e 's/^"//' -e 's/"$//')
SECRET_ACCESS_KEY=$(echo $OUTPUT | jq '.Credentials.SecretAccessKey' | sed -e 's/^"//' -e 's/"$//')
SESSION_TOKEN=$(echo $OUTPUT | jq '.Credentials.SessionToken' | sed -e 's/^"//' -e 's/"$//')

aws configure set aws_access_key_id $ACCESS_KEY_ID --profile mfa
aws configure set aws_secret_access_key $SECRET_ACCESS_KEY --profile mfa
aws configure set aws_session_token $SESSION_TOKEN --profile mfa