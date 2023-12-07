#!/bin/bash

#dynamically determine all site pages
sitemap=$(curl https://www.rise8.us/sitemap.xml)
parsed=$(echo "$sitemap" | sed "s/<.*>//g")

LIGHTHOUSE_REPORTS_FOLDER="./lighthouse-reports/"
threshold=90

#check the score against the threshold and send a slack message if it fails
function checkScore() {
  # TODO: send the slack message to the correct channel - maybe lower threshold so the channel isn't spammed?
  if (( $(echo "$1 < $threshold" | bc -l) )); then
      curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$2 failed for page: $3. Score is below $threshold. $2 score: $1\"}" "$SLACK_SECRET"
  #else
      #curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$2 passed for page: $3. Score is above or equal to $threshold. $2 score: $1\"}" "${SLACK_SECRET}"
  fi
}

while read -r line
do
  if [[ ! -z "${line//[[:space:]]*}" ]]; then
    echo "line:" "$line"
    nameForMessage=$(echo "$line" | tr -d '[:space:]');
    filename=$(echo "$line" | sed "s/https:\/\/www\.//g" | sed "s/\./-/g" | sed "s/\//-/g" | tr -d '[:space:]');# | sed "s/$/delaney/")
    REPORT_FILE="$LIGHTHOUSE_REPORTS_FOLDER""$filename"".json"
    echo "REPORT_FILE: $REPORT_FILE"

    # Get the performance score using jq, convert to float, and multiply by 100
    performance_score=$(jq -r '.categories.performance | .score * 100' "$REPORT_FILE")
    accessibility_score=$(jq -r '.categories.accessibility | .score * 100' "$REPORT_FILE")
    best_practices_score=$(jq -r '.categories | .["best-practices"] | .score * 100' "$REPORT_FILE")
    seo_score=$(jq -r '.categories.seo | .score * 100' "$REPORT_FILE")
    pwa_score=$(jq -r '.categories.pwa | .score * 100' "$REPORT_FILE")

    checkScore "$performance_score" "Performance" "$nameForMessage"
    checkScore "$accessibility_score" "Accessibility" "$nameForMessage"
    checkScore "$best_practices_score" "Best Practices" "$nameForMessage"
    checkScore "$seo_score" "SEO" "$nameForMessage"
    checkScore "$pwa_score" "PWA" "$nameForMessage"
  fi
done <<< "$parsed"



