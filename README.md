# gltrace

Terminal-first GitLab pipeline/job log explorer. Pulls job traces straight into your terminal so you never have to click through the GitLab UI again.

## Why

**CI jobs fail.** The typical workflow is: open GitLab, find the pipeline, click the failed job, scroll through the log, copy the relevant bit, paste it somewhere. That's slow for humans and impossible for agents.

gltrace fixes both problems:

- **For developers** — run one command, get the failed job log in your terminal. No browser, no clicking.
- **For AI coding agents** — agents like Claude Code can call `gltrace` directly to read CI failures, diagnose issues, and fix code without you having to copy-paste logs back and forth. Just point the agent at a pipeline and let it work.

```bash
# You: "CI failed, fix it"
# Agent runs:
gltrace --project-id 74826611 --pipeline-id 2338349786 --status failed
# Agent reads the trace, finds the error, fixes the code.
```

## Features

- Works with **any GitLab instance** (self-hosted or gitlab.com)
- Two usage styles:
  - **No args** — launches a **gum wizard** (prompts for all fields)
  - **Args mode** — fully non-interactive, deterministic output (ideal for agents)
- Pipeline status filtering (`--status failed`, `--status success`, etc.)
- Optional recursive scope for child pipelines (`--include-downstream`)
- Stage/job selection in pipeline mode (`--stage`, `--job`)
- Direct job trace mode (`--job-id`)
- Save trace output to file (`--save`, `--output`)

## Requirements

- `bash`
- `curl`
- `jq`
- `gum` for no-args wizard mode
  - If missing, `gltrace` attempts auto-install (brew/apt/pacman)
- Optional: `fzf` (only used when interactive stage/job selection is needed outside wizard logic)

## Install

```bash
cd /path/to/gltrace
make install-local
```

This copies the script to `~/.local/bin/gltrace`. Make sure `~/.local/bin` is in your `PATH`.

## Quick start

```bash
export GITLAB_URL="https://gitlab.com"
export GITLAB_TOKEN="<your-token>"
```

### Wizard mode (no args)

```bash
gltrace
```

### Args mode

```bash
# List failed jobs in a pipeline
gltrace --project-id 74826611 --pipeline-id 123456 --status failed

# Get a specific job's trace
gltrace --project-id 74826611 --job-id 35012984
```

## Usage with AI agents

gltrace is designed to work as a tool that AI coding agents can call. When a CI pipeline fails:

1. Give the agent the pipeline ID
2. The agent calls `gltrace --status failed` to pull the job traces
3. The agent reads the error, identifies the root cause, and fixes the code
4. No copy-pasting, no browser tabs, no back-and-forth

This works with any agent that can execute shell commands — Claude Code, Cursor, Aider, etc.

**Example agent workflow:**
```bash
# Agent lists failed jobs
gltrace --project-id 74826611 --pipeline-id 2338349786 --status failed

# Agent fetches a specific job's full trace
gltrace --project-id 74826611 --job-id 13192465937

# Agent reads the trace output, finds the error, and applies a fix
```

## Usage

```bash
gltrace [options]
```

Core options:
- `--gitlab-url <url>`
- `--project-id <id>`
- `--pipeline-id <id>`
- `--job-id <id>`
- `--token <token>`

Pipeline filtering/selection:
- `--status <value[,value...]>` (e.g. `failed`, `success`, `failed,success`)
- `--include-downstream` (include bridge-triggered child pipeline jobs)
- `--source-pipeline-id <id>` (restrict to one source pipeline from `pipe:<id>` hints)
- `--stage <name>`
- `--job <name>`

Output:
- `--save`
- `--output <path>`
- `--raw`

UI:
- `--picker <auto|fzf|gum|select>`
- `--no-interactive`

## Environment variables

CLI flags override env vars:

- `GITLAB_URL`
- `GITLAB_PROJECT_ID`
- `GITLAB_TOKEN`
- `GITLAB_PIPELINE_ID` (optional default)
- `GITLAB_JOB_ID` (optional default)

## Examples

```bash
# No-args wizard
gltrace

# Failed jobs only (parent pipeline only)
gltrace --pipeline-id 123456 --status failed --stage test --job integration-tests

# Failed jobs including downstream/child pipelines
gltrace --pipeline-id 123456 --include-downstream --status failed --stage test --job integration-tests

# Success jobs only
gltrace --pipeline-id 123456 --status success --stage deploy --job deploy-prod

# Direct job trace
gltrace --job-id 35012984

# Save output
gltrace --job-id 35012984 --output ./logs/job-35012984.log
```

## Notes

- In args mode, gltrace avoids prompts. If your selector matches multiple jobs, it exits with a clear message and shows matching jobs.
- Prefer `GITLAB_TOKEN` env var over `--token` to avoid leaking secrets in shell history.
