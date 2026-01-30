#!/usr/bin/env bash

set -e

scripts_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$scripts_dir/ralph-setup"

opencode run "$prompt" --agent="$agent" "${forwarded_args[@]}"
