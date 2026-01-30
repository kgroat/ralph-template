# Ralph Wiggum agent
[Ralph Wiggum](https://ghuntley.com/ralph/) is an idea of how to create your own agent using a simple bash loop. I've not used Geoffrey's ideas in their most basic form. Instead, I've taken the advice of [Matt Pocock](https://www.aihero.dev/tips-for-ai-coding-with-ralph-wiggum) to make the agent smarter.

The idea is to minimize context rot experienced by the AI. This is done by making sure it only has a small piece of work to do with each invocation. This is accomplished by breaking a large feature into a set of bite-sized tasks, allowing the AI choose which of those tasks to implement, and having it implement only that one task at a time. Once the task is done, you repeat the process until all of the tasks are done, or until a defined iteration limit is reached.

I've taken a lot of the [Ralph prompt](./prompts/ralph.example.md) directly from Matt Pocock. He gives a lot of good advice on how to guide Ralph to behave the way you want it to. Each portion of the prompt is designed to enforce a specific behavior that we want to encourage. If you wish to override the default Ralph prompt, you can create a `ralph.md` file next to the example.

## Prerequisites
Right now, Ralph is designed to work with the [`opencode`](https://opencode.ai/) CLI. If anyone has a differend preferred CLI (such as Claude Code or Codex), feel free to create a version which uses that tool.

You'll first need to install `opencode`. You can use the free models or bring your own provider. To log into your provider of choice run `opencode auth login` and search for the provider you want to use.

## Suggestions
### Ralph-specific agent
I suggest creating an `opencode.json` file with some [agents defined](https://opencode.ai/docs/agents/). You can see an example in [`opencode.example.json`](../opencode.example.json). By default, Ralph will use the `build` agent, but you can override this by creating an `ai/scripts/personal-defaults.env` file. The contents can be used to tune Ralph's default behavior. It should simply be a set of environment variables to modify the following:
```bash
agent="build" # set the default agent for Ralph to use
iterations="10" # set the default maximum number of iterations Ralph can take
```

I would suggest at the very least making a specific `ralph` agent in `opencode.json` and setting Ralph up to use it. You can explicitly deny Ralph from prompting for input by setting `"question": "deny"` in its configuration. This ensures that Ralph will work on the task without trying to ask for input.

### Ralph worktree
I also suggest creating a [git worktree](https://git-scm.com/docs/git-worktree) where Ralph can do work. This is useful for two reasons:
1. It does not interrupt your development flow. You can continue working in the base repo while Ralph does his thing elsewhere.
2. You can install a pre-commit hook for Ralph but not for your project root, to ensure that Ralph doesn't commit broken code.

To create a worktree for Ralph, start by running the following commands:
```bash
# enable worktree-level configs so that you can configure husky on a per-worktree basis
# (you only need to run this once, even if you create multiple worktrees)
git config extensions.worktreeconfig true

# create a directory called worktrees/ralph with a new worktree and a new branch called [branch_name] checked out inside it
# (omit -b if you want to check out an existing branch)
git worktree add worktrees/ralph -b [branch_name]
```

If you wish to use a pre-commit hook, such as the one I've included using husky, you should also:
```bash
# go into the new worktree
cd worktrees/ralph

# install the husky hooks and configure them to be used in the worktree
npx husky && git config --worktree core.hooksPath $(realpath ./.husky/_)

# return to the project root
cd ../..

# Remove husky from the root config because husky installs itself for the whole repo, even when installed from inside a worktree
git config unset core.hooksPath
```

### Worktree alternative
If you prefer not to deal with worktrees, you can instead clone the repo in a separate directory specifically for Ralph. If you do, and you want to use `husky`, all you have to do is run `npx husky` in the root of the project directory.

## Creating a plan
The way I've set up Ralph, you first start with a plan. A plan consists of three things:
* A directory inside `ai/plans` -- the name of this directory is the name of your plan
* A `design.md` file which is a detailed description of what the plan intends to accomplish
* A `prd.json` file which contains the tasks needed to complete the plan

You can create these manually, but I suggest rubber-ducking with your favorite model to first generate the design, then create the prd from that design. You might want to create two additional agents in your `opencode.json` file, one specific to generating `design.md` files and one for `prd.json` files.

When generating `design.md` you should tell the model to be concise and to ask clarifying questions; sometimes the AI will ask questions you didn't think to tell it about. You should shoot for the design to not be more than 200 lines long.

Next, you should ask a model to generate the `prd.json` file. Tasks should be small, self-contained updates to the code that can be implemented in a one-shot manner and don't lead to broken types or tests. Ideally, each task should have 3-5 clear steps. Make sure to tell the model to stick to the `ai/prd_schema.json` JSON schema when generating the prd.

For the sake of creating custom design or prd agents, you can create files inside the `ai/prompts` directory. As long as the files don't match `*.example.*`, they will be ignored by git.

## Running Ralph
I've given Ralph two modes:
* `./ai/scripts/ralph-once.sh [plan_name]` allows Ralph to pick up a single task, implement it, and commit it.
  * This is useful for getting used to Ralph and figuring out how different prompts, `design.md` details, or `prd.json` updates affect its output.
  * It is also useful for making sure that things are moving in the direction you want.
  * You can use your favorite diff tool to view the changes made by Ralph to verify its code is correct.
  * Matt Pocock calls this "human-in-the-loop" or "HIL" mode.
* `./ai/scripts/ralph.sh [plan_name]` allows Ralph to run in a loop -- picking up tasks and implementing them as it sees fit.
  * This is useful for a fire-and-forget style of implementation.
  * Ralph will produce a commit for every task completed, allowing you to check its work in a digestible manner.
  * You can specify a maximum number of iterations Ralph can take using the `--iterations=<number>` option.
  * Matt Pocock calls this "AFK" mode.

## progress.md
Every time Ralph finishes a task, it should update `progress.md` inside of your plan directory. The idea is twofold:
* Ralph should have a scratchpad it can use to communicate decisions with future iterations
* You should have a way to see its thought process throughout its implementation

`progress.md` is not checked in to git. I've gone back and forth on whether I like this. Matt Pocock suggests not checking it in mostly because sometimes between Ralph runs, it is useful to clear it out. It can also potentially get lengthy, and can potentially introduce context rot. That said, it might be useful to see the decisions made by Ralph in a PR. I figure that, if you think it's useful to check in, you can force add it using `git add --force`.
