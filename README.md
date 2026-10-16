# REPLACE_ME

<!-- Generated from https://github.com/SierranaTech/go-service-template -->

Short one-liner describing what this service does.

## Getting started

The template ships with the org-standard tooling; a fresh clone should
run cleanly with just `mise install`.

```bash
mise install                    # Go, golangci-lint, ...
mise run sync-lint-config       # pull the current .golangci.yml (optional; template ships a copy)
mise run test-all               # fmt + tidy + vet + lint + test
mise run run                    # run the service locally
mise run docker-build           # build the container image
```

## Template checklist

After generating this repo from the template, do these once:

- [ ] Search-and-replace `REPLACE_ME` (README title, `go.mod` module path,
      `mise.toml` docker image tag, this checklist entry).
- [ ] Register the repo with CI and an ECR repository. Without those, the
      `build` and `retag` jobs in `.github/workflows/ci.yml` have nothing
      to push to and no role to assume.
- [ ] Delete this "Template checklist" section.

## CI shape

- `vet`, `lint`, `test`, `build` run in parallel. All
  fail fast; a broken Dockerfile surfaces without waiting for tests.
- `build` uses `SierranaTech/actions/build-push-ecr` — on `push:main` it
  publishes to ECR; on PRs it just validates that the image compiles.
- `retag` runs only on `push:main` after all four gates pass, using
  `SierranaTech/actions/retag-ecr` to promote the image to the
  `stable-<sha>-<epoch>` tag that FluxCD's `ImageUpdateAutomation`
  watches to roll the deployment forward.

## Layout

- `cmd/main.go` — service entry point
- `internal/` — implementation packages
- `Dockerfile` — multi-stage distroless build for K8s
- `.github/workflows/ci.yml` — parallel vet/lint/test jobs
- `mise.toml` — canonical task set (`fmt`, `tidy`, `vet`, `lint`, `test`,
  `test-all`, `sync-lint-config`, `build`, `run`, `docker-build`)
