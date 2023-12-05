#!/bin/bash

# Path to the JSON file
JSON_FILE="reports-test.json"
# Threshold for the alert
threshold=90

# Get the performance score using jq, convert to float, and multiply by 100
performance_score=$(jq -r '.categories.performance | .score * 100' "$JSON_FILE")
accessibility_score=$(jq -r '.categories.accessibility | .score * 100' "$JSON_FILE")
best_practices_score=$(jq -r '.categories.best-practices | .score * 100' "$JSON_FILE")
seo_score=$(jq -r '.categories.seo | .score * 100' "$JSON_FILE")
pwa_score=$(jq -r '.categories.pwa | .score * 100' "$JSON_FILE")


# Check if the performance score is below the threshold
#if (( $(echo "$performance_score < $threshold" | bc -l) )); then
#    # Generate an alert
#    echo "Alert: Performance score is below 90. Current score: $performance_score"
#    curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"Performance failed! score: $performance_score\"}" "$SLACK_SECRET"
#else
#    echo "Performance score is above or equal to 90. Current score: $performance_score"
#    curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"Performance score is above or equal to 90. Current score: $performance_score\"}" "${SLACK_SECRET}"
#fi


function checkScore() {
  # Check if the category score is below the threshold
  if (( $(echo "$1 < $threshold" | bc -l) )); then
      # Generate an alert
      #echo "Alert: $2 score is below 90. Current score: $1"
      curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$2 failed. Score is below $threshold $2 score: $1\"}" "$SLACK_SECRET"
  else
      #echo "$2 score is above or equal to 90. Current score: $1"
      curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$2 passed. Score is above or equal to $threshold $2 score: $1\"}" "${SLACK_SECRET}"
  fi
}

checkScore "$performance_score" "Performance"
checkScore "$accessibility_score" "Accessibility"
checkScore "$best_practices_score" "Best Practices"
checkScore "$seo_score" "SEO"
checkScore "$pwa_score" "PWA"


