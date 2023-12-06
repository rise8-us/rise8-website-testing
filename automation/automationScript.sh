#!/bin/bash

# Path to the JSON file
JSON_FILE="reports-test.json"
# Threshold for the alert
threshold=90

# Get the performance score using jq, convert to float, and multiply by 100
performance_score=$(jq -r '.categories.performance | .score * 100' "$JSON_FILE")
accessibility_score=$(jq -r '.categories.accessibility | .score * 100' "$JSON_FILE")
best_practices_score=$(jq -r '.categories | .["best-practices"] | .score * 100' "$JSON_FILE")
seo_score=$(jq -r '.categories.seo | .score * 100' "$JSON_FILE")
pwa_score=$(jq -r '.categories.pwa | .score * 100' "$JSON_FILE")

function checkScore() {
  # Check if the category score is below the threshold, and send slack alert if it fails (TODO: sends message either way right now)
  # TODO: send the slack message to the correct channel
  if (( $(echo "$1 < $threshold" | bc -l) )); then
      curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$2 failed. Score is below $threshold. $2 score: $1\"}" "$SLACK_SECRET"
  else
      curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$2 passed. Score is above or equal to $threshold. $2 score: $1\"}" "${SLACK_SECRET}"
  fi
}

checkScore "$performance_score" "Performance"
checkScore "$accessibility_score" "Accessibility"
checkScore "$best_practices_score" "Best Practices"
checkScore "$seo_score" "SEO"
checkScore "$pwa_score" "PWA"


