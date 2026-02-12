# USAGE.md

Detailed usage examples for `gltrace`.

## 1) Setup

```bash
cd /Users/mpatel/projects/farhaan/gltrace
chmod +x ./gltrace

export GITLAB_URL="https://gitlab.eng.roku.com"
export GITLAB_PROJECT_ID="31043"
export GITLAB_TOKEN="YOUR_TOKEN"
```

---

## 2) Wizard mode (no args)

```bash
./gltrace
```

Behavior:
- Uses `gum` prompts for URL, project, token, mode, filters, selection, save options
- If `gum` is missing, script attempts auto-install

---

## 3) Args mode (non-interactive)

When you pass flags, prompts are disabled. Output is deterministic.

### 3.1 Direct job

```bash
./gltrace --job-id 35012984
```

### 3.2 Pipeline with explicit selectors

```bash
./gltrace --pipeline-id 123456 --stage build --job unit-tests
```

### 3.3 Failed jobs only (parent pipeline)

```bash
./gltrace --pipeline-id 123456 --status failed --stage test --job integration-tests
```

### 3.4 Failed jobs including downstream/child pipelines

```bash
./gltrace --pipeline-id 123456 --include-downstream --status failed --stage test --job integration-tests
```

### 3.5 Success jobs only

```bash
./gltrace --pipeline-id 123456 --status success --stage deploy --job deploy-prod
```

### 3.6 Multiple statuses

```bash
./gltrace --pipeline-id 123456 --status failed,success --stage test --job smoke
```

### 3.7 Disambiguate by source child pipeline

When multiple downstream pipelines have same stage/job names, first run broad and note `pipe:<id>` hints, then pin one:

```bash
./gltrace --pipeline-id 123456 --include-downstream --status failed --source-pipeline-id 7685851 --stage Apply
```

### 3.8 Fetch logs for each job

Direct by job id (recommended):

```bash
./gltrace --project-id 31043 --job-id 35012984
./gltrace --project-id 31043 --job-id 35012983
./gltrace --project-id 31043 --job-id 35012974
```

Save each to file:

```bash
./gltrace --project-id 31043 --job-id 35012984 --output ./logs/35012984.log
./gltrace --project-id 31043 --job-id 35012983 --output ./logs/35012983.log
```

Or via filtered selectors:

```bash
./gltrace \
  --project-id 31043 \
  --pipeline-id 7684859 \
  --include-downstream \
  --source-pipeline-id 7685851 \
  --status failed \
  --stage Apply \
  --job "assign-non-virtual-repos-apply: [ava, us-east-1]"
```

If selectors are ambiguous in args mode, gltrace exits and prints matching job hints.

---

## 4) Save output

Auto filename:

```bash
./gltrace --job-id 35012984 --save
```

Explicit file:

```bash
./gltrace --job-id 35012984 --output ./logs/my-job.log
```

---

## 5) Raw output / piping

```bash
./gltrace --job-id 35012984 --raw
./gltrace --job-id 35012984 --raw | tail -n 200
```

---

## 6) Environment defaults

```bash
export GITLAB_PIPELINE_ID="123456"
./gltrace --stage build --job unit-tests

export GITLAB_JOB_ID="35012984"
./gltrace
```

CLI flags override env vars.

---

## 7) Makefile helpers

```bash
make help
make usage
make check
make deps
make run PIPELINE_ID=123456
make test
make install-local
```
