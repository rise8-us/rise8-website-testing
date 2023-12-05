#!/bin/bash

# Path to the JSON file
JSON_FILE="./test-results/reports-test.json"

# Get the performance score using jq, convert to float, and multiply by 100
performance_score=$(jq -r '.categories.performance | .score * 100' "$JSON_FILE")

# Threshold for the alert
performance_threshold=90

    curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' https://hooks.slack.com/services/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

# Check if the performance score is below the threshold
if (( $(echo "$performance_score < $performance_threshold" | bc -l) )); then
    # Generate an alert
    echo "Alert: Performance score is below 90. Current score: $performance_score"
    curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"Performance failed! score: $performance_score\"}" https://hooks.slack.com/services/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
    #curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"Performance failed!score: $performance_score\"}" https://hooks.slack.com/services/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else
else
    echo "Performance score is above or equal to 90. Current score: $performance_score"
    curl -X POST -H 'Content-type: application/json' --data '{"text":"Performance passed!"}' https://hooks.slack.com/services/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
fi
