#!/usr/bin/env bash

set -e

scripts_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$scripts_dir/ralph-setup"

# For each iteration, run opencode run with the specified plan and agent
for ((i=1; i<=$iterations; i++)); do
  result=$(opencode run "$prompt" --agent="$agent" "${forwarded_args[@]}")

  echo "$result"

  if [[ "$result" == *"<promise>COMPLETE</promise>"* ]]; then
    echo "PRD complete, exiting."
    exit 0
  fi
done

echo "Reached maximum iterations ($iterations) without completing PRD."
exit 1
