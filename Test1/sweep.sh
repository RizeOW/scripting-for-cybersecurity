#!/bin/bash

TOTAL=0

for INDICATOR in $(cat exam-data/intel/iocs.txt); do
    LOGS=0

    for LOGFILE in exam-data/case/logs/*.log; do
        if [ -f "$LOGFILE" ]; then
            COUNT=$(grep -cwF "$INDICATOR" "$LOGFILE")

            if [ "$COUNT" -gt 0 ]; then
                echo "$INDICATOR | $(basename "$LOGFILE") | $COUNT"
                LOGS=$((LOGS + 1))
                TOTAL=$((TOTAL + COUNT))
            fi
        fi
    done

    echo "$INDICATOR was found in $LOGS log(s)"
done

echo "Total matching lines: $TOTAL"
echo ""
echo "Hash check:"

for FILE in exam-data/case/evidence/*; do
    if [ -f "$FILE" ]; then
        HASH=$(md5sum "$FILE" | awk '{print $1}')

        if grep -qxF "$HASH" exam-data/intel/iocs.txt; then
            echo "KNOWN BAD: $FILE"
        else
            echo "clean : $FILE"
        fi
    fi
done
