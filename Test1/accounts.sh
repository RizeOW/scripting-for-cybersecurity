#!/bin/bash

FIRST_LINE=1
ACTIVE=0
DISABLED=0

while IFS=',' read -r USERNAME ROLE STATUS DEPT || [ -n "$USERNAME" ]; do
    if [ "$FIRST_LINE" -eq 1 ]; then
        FIRST_LINE=0
        continue
    fi

    DEPT=${DEPT%$'\r'}
    LOGINS=$(grep -cF "Accepted password for $USERNAME " exam-data/case/logs/auth.log)

    echo "$USERNAME | $ROLE | $STATUS | $DEPT | logins: $LOGINS"

    if [ "$STATUS" = "active" ]; then
        ACTIVE=$((ACTIVE + 1))
    elif [ "$STATUS" = "disabled" ]; then
        DISABLED=$((DISABLED + 1))
    fi

    if [ "$STATUS" = "disabled" ] && [ "$LOGINS" -gt 0 ]; then
        echo "ALERT: $USERNAME has successful logins"
    fi
done < exam-data/intel/users.csv

echo "Active accounts: $ACTIVE"
echo "Disabled accounts: $DISABLED"
