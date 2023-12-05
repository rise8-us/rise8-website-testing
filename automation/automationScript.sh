#!/bin/bash

#SLACK_SECRET="$1"
#if [ "$SLACK_SECRET" == null ]
#then
#    echo "Please provide a slack secret"
#    exit 1
#fi

# Path to the JSON file
JSON_FILE="test-results/reports-test.json"
#JSON_FILE=lighthouse-results

# Get the performance score using jq, convert to float, and multiply by 100
performance_score=$(jq -r '.categories.performance | .score * 100' "$JSON_FILE")

# Threshold for the alert
performance_threshold=90

curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' "$SLACK_SECRET"

# Check if the performance score is below the threshold
if (( $(echo "$performance_score < $performance_threshold" | bc -l) )); then
    # Generate an alert
    echo "Alert: Performance score is below 90. Current score: $performance_score"
    curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"Performance failed! score: $performance_score\"}" "$SLACK_SECRET"
else
    echo "Performance score is above or equal to 90. Current score: $performance_score"
    curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"Performance score is above or equal to 90. Current score: $performance_score\"}" "${SLACK_SECRET}"
fi
