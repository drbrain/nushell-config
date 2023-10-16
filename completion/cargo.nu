use wrapper cargo *

def color [] {
  ["auto", "always", "never"]
}

def edition [] {
  [
    "2015",
    "2018",
    "2021",
  ]
}

def timing [] {
  ["html", "json"]
}

def vcs [] {
  [
    "git",
    "hg",
    "pijul",
    "fossil",
    "none",
  ]
}

# Add dependencies to a Cargo.toml manifest file
export extern "cargo add" [
  dep: string               # Reference to package to add as a dependency
  --no-default-features     # Disable the default features
  --default-features        # Re-enable the default features
  --features(-F): string    # Comma-separated list of features to activate
  --optional                # Mark the dependency as optional
  --no-optional             # Mark the dependency as required
  --rename: string          # Rename the dependency
  --dry-run                 # Don't write the manifest
  --package: string         # Package to modify
  --manifest-path: string   # Path to Cargo.toml

  --path: path              # Filesystem path to local crate to add
  --git: string             # Git repository location
  --branch: string          # Git branch to download crate from
  --tag: string             # Git tag to download crate from
  --rev: string             # Git reference to download crate from
  --registry                # Package registry for this dependency

  --frozen                  # Require Cargo.lock and cache are up to date
  --locked                  # Require Cargo.lock is up to date
  --offline                 # Run without accessing the network

  --dev                     # Add package as development dependency
  --build                   # Add package as build dependency
  --target: string          # Add packages to this target platform

  --color: string@color     # Set coloring
  --config-file: string     # Config file [default: workspace-root/.config/nextest.toml]
  -Z: string                # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details

  --quiet(-q)               # Do not print cargo log messages
  --verbose(-v)             # Use verbose output (-vv very verbose/build.rs output)
  --help(-h)                # Print help information
]

# Compile a local package and all of its dependencies
export extern "cargo build" [
  --all-features            # Activate all available features
  --all-targets             # Build all targets
  --bench: string           # Build only the specified bench target
  --benches                 # Build all benches
  --bin: string             # Build only the specified binary
  --bins                    # Build all binaries
  --build-plan              # Output the build plan in JSON (unstable)
  --color: string@color     # When to color output
  --config: string          # Override a configuration value (unstable)
  --example: string         # Build only the specified example
  --examples                # Build all examples
  --exclude: string         # Exclude packages from the build
  --features: string        # Space or comma separated list of features to activate
  --frozen                  # Require Cargo.lock and cache are up to date
  --future-incompat-report  # Outputs a future incompatibility report at the end of the build
  --help(-h)                # Print help information
  --ignore-rust-version     # Ignore `rust-version` specification in packages
  --jobs(-j): number        # Number of parallel jobs, defaults to # of CPUs
  --keep-going              # Do not abort the build as soon as there is an error (unstable)
  --lib                     # Build only this package's library
  --locked                  # Require Cargo.lock is up to date
  --manifest-path: string   # Path to Cargo.toml
  --message-format: string  # Error format
  --no-default-features     # Do not activate the `default` feature
  --offline                 # Run without accessing the network
  --out-dir: string         # Copy final artifacts to this directory (unstable)
  --package(-p): string     # Package to build (see `cargo help pkgid`)
  --profile: string         # Build artifacts with the specified profile
  --quiet(-q)               # Do not print cargo log messages
  --release(-r)             # Build artifacts in release mode, with optimizations
  --target-dir: string      # Directory for all generated artifacts
  --target: string          # Build for the target triple
  --test: string            # Build only the specified test target
  --tests                   # Build all tests
  --timings: string@timing  # Timing output formats (unstable, comma separated)
  --unit-graph              # Output build graph in JSON (unstable)
  --verbose(-v)             # Use verbose output (-vv very verbose/build.rs output)
  --workspace               # Build all packages in the workspace
  -Z: string                # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

# Create a new cargo package in an existing directory
export extern "cargo init" [
  path?: path               # Path to cargo project
  --bin                     # Use a binary (application) template
  --lib                     # Use a library template
  --edition: number@edition # Set crate edition
  --vcs: string@vcs         # Initialize a VCS repository
  --registry: string        # Registry to use

  --frozen                  # Require Cargo.lock and cache are up to date
  --locked                  # Require Cargo.lock is up to date
  --offline                 # Run without accessing the network

  --color: string@color     # Set coloring
  --config: string          # Override a configuration value
  -Z: string                # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details

  --quiet(-q)               # Do not print cargo log messages
  --verbose(-v)             # Use verbose output (-vv very verbose/build.rs output)
  --help(-h)                # Print help information
]

# Install a Rust binary
export extern "cargo install" [
  ...spec: string          # Crate to install
  --quiet(-q)              # Do not print cargo log messages
  --version: string        # Specify a version to install
  --git: string            # Git URL to install the specified crate from
  --branch: string         # Branch to use when installing from git
  --tag: string            # Tag to use when installing from git
  --rev: string            # Specific commit to use when installing from git
  --path: string           # Filesystem path to local crate to install
  --list                   # list all installed packages and their versions
  --jobs(-j): int          # Number of parallel jobs, defaults to of CPUs.
  --keep-going             # Do not abort the build as soon as there is an error (unstable)
  --force(-f)              # Force overwriting existing crates or binaries
  --no-track               # Do not save tracking information
  --features(-F): string   # Space or comma separated list of features to activate
  --all-features           # Activate all available features
  --no-default-features    # Do not activate the `default` feature
  --profile: string        # Install artifacts with the specified profile
  --debug                  # Build in debug mode (with the 'dev' profile) instead of release mode
  --bin: string            # Install only the specified binary
  --bins                   # Install all binaries
  --example: string        # Install only the specified example
  --examples               # Install all examples
  --target: string         # Build for the target triple
  --target-dir: path       # Directory for all generated artifacts
  --root: path             # Directory to install packages into
  --index: string          # Registry index to install from
  --registry: string       # Registry to use
  --ignore-rust-version    # Ignore `rust-version` specification in packages
  --message-format: string # Error format
  --timings: string@timing # Timing output formats (unstable, comma separated)
  --help(-h)               # Print help
  --verbose(-v)            # Use verbose output (-vv very verbose/build.rs output)
  --color: string@color    # Coloring: auto, always, never
  --frozen                 # Require Cargo.lock and cache are up to date
  --locked                 # Require Cargo.lock is up to date
  --offline                # Run without accessing the network
  --config: string         # Override a configuration value
  -Z: string               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

def nextest [] {
  ["list", "run"]
}

# A next-generation test runner
export extern "cargo nextest" [
  command?: string@nextest # Command to run
  --color: string@color    # When to color output
  --config-file: string    # Config file [default: workspace-root/.config/nextest.toml]
  --help(-h)               # Print help information
  --manifest-path: string  # Path to Cargo.toml
  --verbose(-v)            # Use verbose output
  --version(-V)            # Print version information
]

def nextest_ignore [] {
  ["default", "ignored-only", "all"]
}

def nextest_message_format [] {
  ["human", "json", "json-pretty"]
}

# List tests in the workspace
export extern "cargo nextest list" [
  --all-features           # Activate all available features
  --all-targets            # Test all targets
  --bench: string          # Test only the specified bench target
  --benches                # Test all benches
  --bin: string            # Test only the specified binary
  --bins                   # Test all binaries
  --build-jobs: number     # Number of jobs to run
  --cargo-profile: string  # Build artifacts with the specified Cargo profile
  --color: string@color    # When to color output
  --config-file: string    # Config file [default: workspace-root/.config/nextest.toml]
  --config: string         # Override a configuration value (unstable)
  --exclude: string        # Exclude packages from the build
  --features: string       # Space or comma separated list of features to activate
  --frozen                 # Require Cargo.lock and cache are up to date
  --future-incompat-report # Outputs a future incompatibility report at the end of the build
  --help(-h)               # Print help information
  --ignore-rust-version    # Ignore "rust-version" specification in packages
  --lib                    # Test only library unit tests
  --locked                 # Require Cargo.lock is up to date
  --manifest-path: string  # Path to Cargo.toml
  --message-format(-T): string@nextest_message_format # Output format
  --no-default-features    # Do not activate the "default" feature
  --offline                # Run without accessing the network
  --package(-p): string    # Package to test
  --partition: string      # Test partition, e.g. hash:1/2 or count:2/3
  --release                # Build artifacts in release mode, with optimizations
  --run-ignored: string@nextest_ignore # Run ignored tests
  --target-dir: string     # Directory for all generated artifacts
  --target: string         # Build for the target triple
  --test: string           # Test only the specified test target
  --tests                  # Test all targets
  --unit-graph             # Output build graph in JSON (unstable)
  --verbose(-v)            # Use verbose output
  --workspace              # Build all packages in the workspace
  -Z: string               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

def nextest_output [] {
  ["immediate", "immediate-final", "final", "never"]
}

def nextest_status_level [] {
  ["none", "fail", "retry", "slow", "pass", "skip", "all"]
}

# Build and run tests
export extern "cargo nextest run" [
  filter?: string             # Test name filter
  --all-features             # Activate all available features
  --all-targets              # Test all targets
  --bench: string            # Test only the specified bench target
  --benches                  # Test all benches
  --bin: string              # Test only the specified binary
  --bins                     # Test all binaries
  --build-jobs: number       # Number of jobs to run
  --cargo-profile: string    # Build artifacts with the specified Cargo profile
  --color: string@color # When to color output
  --config-file: string      # Config file [default: workspace-root/.config/nextest.toml]
  --config: string           # Override a configuration value (unstable)
  --exclude: string          # Exclude packages from the build
  --fail-fast                # Cancel test run on the first failure
  --failure-output: string@nextest_output # Output stdout and stderr on failure
  --features: string         # Space or comma separated list of features to activate
  --frozen                   # Require Cargo.lock and cache are up to date
  --future-incompat-report   # Outputs a future incompatibility report at the end of the build
  --help(-h)                 # Print help information
  --ignore-rust-version      # Ignore "rust-version" specification in packages
  --lib                      # Test only library unit tests
  --locked                   # Require Cargo.lock is up to date
  --manifest-path: string    # Path to Cargo.toml
  --no-capture               # Run tests serially and do not capture output
  --no-default-features      # Do not activate the "default" feature
  --no-fail-fast             # Run all tests regardless of failure
  --offline                  # Run without accessing the network
  --package(-p): string      # Package to test
  --partition: string        # Test partition, e.g. hash:1/2 or count:2/3
  --profile(-P): string      # Nextest profile to use
  --release                  # Build artifacts in release mode, with optimizations
  --retries: number          # Number of retries for failing tests
  --run-ignored: string@nextest_ignore # Run ignored tests
  --status-level: string@nextest_status_level
  --success-output: string@nextest_output # Output stdout and stderr on success
  --target-dir: string       # Directory for all generated artifacts
  --target: string           # Build for the target triple
  --test-threads(-j): number # Simultaneous threads to run
  --test: string             # Test only the specified test target
  --tests                    # Test all targets
  --unit-graph               # Output build graph in JSON (unstable)
  --verbose(-v)              # Use verbose output
  --workspace                # Build all packages in the workspace
  -Z: string                 # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

def installed [] {
  ( list_installed
  | each {|p|
    let description = $"($p.package) ($p.version)"

    { value: $p.package, description: $description }
  }
  | sort
  )
}

# Remove a rust binary
export extern "cargo uninstall" [
  ...spec: string@installed # Binary to remove
  --quiet(-q)               # Do not print cargo log messages
  --package(-p): string     # Package to uninstall
  --bin: string             # Only uninstall the binary NAME
  --root: string            # Directory to uninstall packages from
  --help(-h)                # Print help
  --verbose(-v)             # Use verbose output (-vv very verbose/build.rs output)
  --color: string@color     # Coloring: auto, always, never
  --frozen                  # Require Cargo.lock and cache are up to date
  --locked                  # Require Cargo.lock is up to date
  --offline                 # Run without accessing the network
  --config: string          # Override a configuration value
  -Z: string                # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

