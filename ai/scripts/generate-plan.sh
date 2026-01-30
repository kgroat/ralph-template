scripts_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
template_dir="$(cd "$scripts_dir/plan_template" >/dev/null 2>&1 && pwd)"
plans_dir="$(cd "$scripts_dir/../plans" >/dev/null 2>&1 && pwd)"

plan_name="$1"

function usage() {
  if [ -z "$npm_lifecycle_event" ]; then
    echo "Usage: $0 <plan_name>"
  else
    echo "Usage: npm run $npm_lifecycle_event <plan_name>"
  fi

  echo ""
  echo "Generates an empty plan in the ai/plans directory."
}

if [ -z "$plan_name" ]; then
  usage >&2
  echo "" >&2
  tput setaf 1 >&2 && tput bold >&2
  echo "Error: plan_name argument is required." >&2
  tput sgr0 >&2
  exit 1
fi

if [ -d "$plans_dir/$plan_name" ]; then
  echo "Plan '$plan_name' already exists." >&2
  exit 1
fi

cp -R "$template_dir" "$plans_dir/$plan_name"
echo "Generated plan '$plan_name' in ai/plans/$plan_name"
