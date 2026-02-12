# gltrace

Terminal-first GitLab pipeline/job log explorer for local agents.

## Features

- Works with **any GitLab URL** (self-hosted or gitlab.com)
- Interactive pipeline navigation: **stage -> job -> trace**
- Direct job trace mode (`--job-id`)
- Stage/job preselection (`--stage`, `--job`) for scripted use
- Optional picker integration: **fzf**, **gum**, or bash `select`
- Save trace output to file (`--save`, `--output`)
- Env-var based configuration for easy local setup

## Requirements

- `bash`
- `curl`
- `jq`
- Optional UI tools:
  - `fzf` (preferred in `--picker auto`)
  - `gum` (fallback before bash select)

## Quick Start

```bash
chmod +x ./gltrace

export GITLAB_URL="https://gitlab.eng.roku.com"
export GITLAB_PROJECT_ID="31043"
export GITLAB_TOKEN="<your-token>"

./gltrace --pipeline-id 123456
```

## Usage

```bash
./gltrace [options]
```

### Modes

- Pipeline mode:

```bash
./gltrace --pipeline-id <id>
```

- Direct job mode:

```bash
./gltrace --job-id <job-id>
```

### Useful Options

- `--stage <name>`: preselect stage
- `--job <name>`: preselect job in selected stage
- `--no-interactive`: fail instead of prompting
- `--save`: save output to auto-generated filename
- `--output <path>`: save output to specific file
- `--picker <auto|fzf|gum|select>`: choose UI picker
- `--raw`: print logs only

## Examples

Interactive stage/job with auto picker:

```bash
./gltrace --pipeline-id 123456
```

Non-interactive exact pick:

```bash
./gltrace --pipeline-id 123456 --stage build --job unit-tests --no-interactive
```

Direct job trace and save:

```bash
./gltrace --job-id 35012984 --save
```

Force fzf picker:

```bash
./gltrace --pipeline-id 123456 --picker fzf
```

## Environment Variables

CLI flags override env vars.

- `GITLAB_URL`
- `GITLAB_PROJECT_ID`
- `GITLAB_TOKEN`
- `GITLAB_PIPELINE_ID` (optional default)
- `GITLAB_JOB_ID` (optional default)

## Security Note

Use environment variables for tokens. Avoid passing tokens on command line where possible.

If a token was shared in chat/history, rotate it.
