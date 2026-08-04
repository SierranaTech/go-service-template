# syntax=docker/dockerfile:1
# =============================================================================
# Single-stage image over a pre-built Go binary.
#
# The binary at ./bin/app must already exist in the build context. Locally,
# run `mise run build` first (or `mise run docker-build`, which depends on
# it). In CI, the `build` job compiles + uploads the binary as an artifact
# and the `docker-push` job downloads it before invoking `docker build`.
#
# Rationale: keeping the Go compile out of the Dockerfile means the same
# binary can be exercised by e2e tests, cached across jobs, and reused by
# the promote step without a second compile. It also makes docker builds
# nearly instant.
#
# Compile-in-image tradeoff: with the compile in the Dockerfile, `docker
# build .` from any working tree Just Works with no prerequisites. With
# this shape, callers must produce ./bin/app first. Worth it for CI
# efficiency; the mise task chain hides the prerequisite locally.
#
# NB: the binary is architecture-specific. For multi-arch images, the CI
# `build` job needs a matrix on GOARCH and a matching `docker buildx build
# --platform=...` invocation. Single-arch (linux/amd64) by default.
# =============================================================================

FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY bin/app /app
USER 65532:65532

# Standard health probe port. Override in K8s via the container's `ports`
# array + env var LISTEN_ADDR if the service needs a different port.
EXPOSE 8080

ENTRYPOINT ["/app"]
