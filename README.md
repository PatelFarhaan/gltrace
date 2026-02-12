# gltrace

Terminal-first GitLab pipeline/job log explorer for local agents.

## Features

- Works with **any GitLab URL** (self-hosted or gitlab.com)
- Two usage styles:
  - **No args** -> launches a **gum wizard** (prompts for all fields)
  - **Args mode** -> fully non-interactive, deterministic output
- Pipeline status filtering via GitLab API scopes (`--status failed`, `--status success`, etc.)
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

## Quick Start

```bash
cd /Users/mpatel/projects/farhaan/gltrace
chmod +x ./gltrace

export GITLAB_URL="https://gitlab.com"
export GITLAB_PROJECT_ID="31043"
export GITLAB_TOKEN="<your-token>"
```

### Wizard mode (no args)

```bash
./gltrace
```

### Args mode

```bash
./gltrace --pipeline-id 123456 --stage build --job unit-tests
```

## Usage

```bash
./gltrace [options]
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

## Environment Variables

CLI flags override env vars:

- `GITLAB_URL`
- `GITLAB_PROJECT_ID`
- `GITLAB_TOKEN`
- `GITLAB_PIPELINE_ID` (optional default)
- `GITLAB_JOB_ID` (optional default)

## Examples

```bash
# No-args wizard
./gltrace

# Failed jobs only (parent pipeline only)
./gltrace --pipeline-id 123456 --status failed --stage test --job integration-tests

# Failed jobs including downstream/child pipelines
./gltrace --pipeline-id 123456 --include-downstream --status failed --stage test --job integration-tests

# Success jobs only
./gltrace --pipeline-id 123456 --status success --stage deploy --job deploy-prod

# Direct job trace
./gltrace --job-id 35012984

# Save output
./gltrace --job-id 35012984 --output ./logs/job-35012984.log
```

## Notes

- In args mode, gltrace avoids prompts. If your selector matches multiple jobs, it exits with a clear message and shows matching jobs.
- Prefer `GITLAB_TOKEN` env var over `--token` to avoid leaking secrets in shell history.
