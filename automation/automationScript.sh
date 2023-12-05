#!/bin/bash

# Path to the JSON file
JSON_FILE="reports-test.json"
# Threshold for the alert
threshold=90

# Get the performance score using jq, convert to float, and multiply by 100
performance_score=$(jq -r '.categories.performance | .score * 100' "$JSON_FILE")
echo "Performance score: $performance_score"


# Check if the performance score is below the threshold
if (( $(echo "$performance_score < $threshold" | bc -l) )); then
    # Generate an alert
    echo "Alert: Performance score is below 90. Current score: $performance_score"
    curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"Performance failed! score: $performance_score\"}" "$SLACK_SECRET"
else
    echo "Performance score is above or equal to 90. Current score: $performance_score"
    curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"Performance score is above or equal to 90. Current score: $performance_score\"}" "${SLACK_SECRET}"
fi
