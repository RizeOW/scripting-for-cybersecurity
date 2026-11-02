#!/bin/bash

COUNT=0
TOTAL=0

while IFS= read -r -d '' LOGFILE; do
    LINES=$(wc -l < "$LOGFILE")
    echo "$LOGFILE: $LINES lines"
    COUNT=$((COUNT + 1))
    TOTAL=$((TOTAL + LINES))
done < <(find exam-data -type f -name "*.log" -print0)

echo "Logs found: $COUNT"
echo "Total lines: $TOTAL"
