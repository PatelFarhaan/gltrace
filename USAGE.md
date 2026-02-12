# USAGE.md

Practical usage examples for `gltrace`.

---

## 0) One-time setup

```bash
cd /Users/mpatel/projects/farhaan/gltrace
chmod +x ./gltrace
```

Set environment variables (recommended):

```bash
export GITLAB_URL="https://gitlab.eng.roku.com"
export GITLAB_PROJECT_ID="31043"
export GITLAB_TOKEN="YOUR_TOKEN"
```

---

## 1) Basic interactive pipeline flow (most common)

```bash
./gltrace --pipeline-id 123456
```

What happens:
1. Shows pipeline summary
2. Lets you select stage
3. Lets you select job
4. Prints logs

---

## 2) Direct job logs (skip pipeline navigation)

```bash
./gltrace --job-id 35012984
```

---

## 3) Preselect stage (skip stage picker)

```bash
./gltrace --pipeline-id 123456 --stage build
```

---

## 4) Preselect both stage + job

```bash
./gltrace --pipeline-id 123456 --stage build --job unit-tests
```

If unique, it goes straight to logs.

---

## 5) Fully non-interactive (great for agents)

```bash
./gltrace --pipeline-id 123456 --stage build --job unit-tests --no-interactive
```

Fails if ambiguous/missing instead of prompting.

---

## 6) Save logs to auto filename

```bash
./gltrace --job-id 35012984 --save
```

Creates file like:

`gltrace-project31043-job35012984-YYYYMMDD-HHMMSS.log`

---

## 7) Save logs to specific file

```bash
./gltrace --job-id 35012984 --output ./logs/my-job.log
```

Also prints logs to terminal.

---

## 8) Raw mode (logs only, no banners)

```bash
./gltrace --job-id 35012984 --raw
```

Good for piping:

```bash
./gltrace --job-id 35012984 --raw | tail -n 200
```

---

## 9) Force picker type

Auto mode is default (`fzf > gum > select`).

```bash
./gltrace --pipeline-id 123456 --picker fzf
./gltrace --pipeline-id 123456 --picker gum
./gltrace --pipeline-id 123456 --picker select
```

---

## 10) Use defaults from env vars for pipeline/job

Pipeline default:

```bash
export GITLAB_PIPELINE_ID="123456"
./gltrace --stage build
```

Job default:

```bash
export GITLAB_JOB_ID="35012984"
./gltrace
```

---

## 11) Override env vars with CLI flags

CLI args always take precedence:

```bash
./gltrace \
  --gitlab-url https://gitlab.example.com \
  --project-id 99999 \
  --pipeline-id 123456 \
  --token ANOTHER_TOKEN
```

---

## 12) Help screen

```bash
./gltrace --help
```

---

## 13) Makefile shortcuts

From the project directory:

```bash
make help
make usage
make check
make deps
make run PIPELINE_ID=123456
make test
make install-local
```

After install (if `~/.local/bin` is in your PATH):

```bash
gltrace --pipeline-id 123456
```

---

## Notes

- Required tools: `curl`, `jq`
- Optional tools: `fzf`, `gum`
- Prefer env var token (`GITLAB_TOKEN`) over passing `--token` in shell history
