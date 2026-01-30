# Ralph Wiggum
This is a template for how I use a Ralph Wiggum loop in my own projects.

## Setup
If you want to use this template, you should:
* Install opencode & configure it with your AI provider(s) of choice
* Copy the `ai` directory into your project
* Add the contents of the root [`.gitignore`](./.gitignore) to your `.gitignore`
* I suggest adding the `design.md`, `prd.json`, and `ralph` agents from [`opencode.example.json`](./opencode.example.json) to your `opencode.json` file; they're each designed to perform one task well.
* Everything is set up to use the `*.example.*` files by default, but you can override them with custom versions.
  * For instance, there is an [`ai/scripts/personal-defaults.example.env`](./ai/scripts/personal-defaults.example.env) file. You can copy it to `ai/scripts/personal-defaults.env` and it will get automatically picked up.
  * Some changes might require updates to references, such as if you want to override the default [`ai/prompts/prd.example.md`](./ai/prompts/prd.example.md) file, you'll also need to update the reference in your `opencode.json` file.

## Usage
For detailed information on how to use the tooling, see [`ai/README.md`](./ai/README.md).
