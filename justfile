set default-list := true

alias build := build-release
alias run := run-dev

rustfmt_config := "--config group_imports=StdExternalCrate"

# Build the production binary.
build-release:
    cargo build --locked --release --package bairdi

# Generate documentation for workspace crates.
doc:
    RUSTDOCFLAGS="-D warnings" cargo doc --locked --workspace --all-features --no-deps

# Format Rust source files.
format:
    cargo fmt --all -- {{rustfmt_config}}

# Check formatting and run Clippy.
lint:
    cargo fmt --all -- --check {{rustfmt_config}}
    cargo clippy --locked --workspace --all-targets --all-features -- -D warnings

# Run lint checks and tests before committing.
[parallel]
pre-commit: lint test

# Run the application in development mode.
run-dev:
    cargo run --locked --package bairdi

# Run unit, integration, and documentation tests.
test:
    cargo nextest run --locked --workspace --all-features
    cargo test --locked --workspace --all-features --doc
