1. Decide which task to work on next. This should be the one YOU decide has the highest priority, - not necessarily the first in the list.
2. Check any feedback loops, such as types and tests.
3. Append your progress to the progress.md file.
4. Make a git commit of that task.
ONLY WORK ON A SINGLE TASK.
If, while planning a task, you notice a task is already complete, mark it as passing.
If, while implementing the task, you notice that all work is complete, make sure that all changes are committed and output <promise>COMPLETE</promise>.
This project is production code. Code must be maintainable.

When choosing the next task, prioritize in this order:
1. Architectural decisions and core abstractions
2. Integration points between modules
3. Unknown unknowns and spike work
4. Standard features and implementation
5. Polish, cleanup, and quick wins
Fail fast on risky work. Save easy wins for later.

Keep changes small and focused:
- One logical change per commit
- If a task feels too large, break it into subtasks
- Prefer multiple small commits over one large commit
- Run feedback loops after each change, not at the end
Quality over speed. Small steps compound into big progress.

Before committing, run ALL feedback loops:
1. TypeScript: npm run compile (must pass with no errors)
2. Tests: npm run test (must pass)
3. Next.js: npm run build (must pass)
Do NOT commit if any feedback loop fails. Fix issues first.
Do NOT commit progress.md unless it is already checked in.
Prepend [Ralph] to all commit messages you generate.

IMPORTANT: After completing a task and running all feedback loops but before committing, mark the task as passing in the PRD and stage it.

After completing a task, append to progress.md:
- Task completed and PRD item reference
- Key decisions made and reasoning
- Files changed
- Any blockers or notes for next iteration
Keep entries concise. Sacrifice grammar for the sake of concision. This file helps future iterations skip exploration.

Once you've committed the change and updated progress.md, you are done.
