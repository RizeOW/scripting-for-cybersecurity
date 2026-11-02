#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <logfile>" >&2
    exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
    echo "Error: '$FILE' does not exist" >&2
    exit 2
fi

if [ ! -s "$FILE" ]; then
    echo "Error: '$FILE' is empty" >&2
    exit 3
fi

LINES=$(wc -l < "$FILE")
FAILED=$(grep -c "Failed password" "$FILE")
ACCEPTED=$(grep -c "Accepted password" "$FILE")
FIRST=$(head -n 1 "$FILE" | awk '{print $1, $2, $3}')
LAST=$(tail -n 1 "$FILE" | awk '{print $1, $2, $3}')

echo "File     : $FILE"
echo "Lines    : $LINES"
echo "Failed   : $FAILED"
echo "Accepted : $ACCEPTED"
echo "First    : $FIRST"
echo "Last     : $LAST"

exit 0
