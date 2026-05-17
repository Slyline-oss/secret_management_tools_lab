#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="$1"
RUNS="${2:-5}"

if [ -z "$CONTAINER_NAME" ]; then
  echo "Izmanto: ./measure-startup.sh <konteinera-nosaukums> [meginajumu skaits]"
  exit 1
fi

echo "Palaisanas laika merisana konteineram: $CONTAINER_NAME"
echo "Meginajumu skaits: $RUNS"
echo

RESULTS_FILE="startup-results-${CONTAINER_NAME}.csv"
echo "run,startup_seconds,total_restart_seconds" > "$RESULTS_FILE"

for i in $(seq 1 "$RUNS"); do
  echo "Run $i..."

  START_TS=$(date +%s.%N)

  docker restart "$CONTAINER_NAME" > /dev/null

  STARTED_LINE=""
  for attempt in {1..60}; do
    STARTED_LINE=$(docker logs "$CONTAINER_NAME" --since "${START_TS}" 2>&1 | grep "Started .* in .* seconds" | tail -n 1 || true)

    if [ -n "$STARTED_LINE" ]; then
      break
    fi

    sleep 1
  done

  END_TS=$(date +%s.%N)

  if [ -z "$STARTED_LINE" ]; then
    echo "Meginajums $i kludains: nav zurnala ieraksta"
    echo "$i,FAILED,FAILED" >> "$RESULTS_FILE"
    continue
  fi

  SPRING_SECONDS=$(echo "$STARTED_LINE" | sed -n 's/.*Started .* in \([0-9.]*\) seconds.*/\1/p')
  TOTAL_SECONDS=$(awk "BEGIN {print $END_TS - $START_TS}")

  echo "Palaisanas laiks: ${SPRING_SECONDS}s"
  echo "Kopejais restartu laiks: ${TOTAL_SECONDS}s"
  echo "$i,$SPRING_SECONDS,$TOTAL_SECONDS" >> "$RESULTS_FILE"

  sleep 3
done

echo
echo "Rezultati saglabati: $RESULTS_FILE"
cat "$RESULTS_FILE"

echo
echo "Videjais:"
awk -F, 'NR>1 && $2!="FAILED" {sum1+=$2; sum2+=$3; count++} END {
  if (count > 0) {
    printf "Videjais SpringBoot laiks: %.3f seconds\n", sum1/count
    printf "Kopejais videjais: %.3f seconds\n", sum2/count
  } else {
    print "Nav veiksmigu meginajumu"
  }
}' "$RESULTS_FILE"