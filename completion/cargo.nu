use wrapper cargo *

def color [] {
  ["auto", "always", "never"]
}

def edition [] {
  [
    2015
    2018
    2021
    2024
  ]
}

def timing [] {
  ["html", "json"]
}

def vcs [] {
  [
    [ value description];
    [ fossil "Fossil SCM" ]
    [ git "git distributed VCS" ]
    [ hg "Mercurial SCM" ]
    [ none "default"]
    [ pijul "Pijul distributed VCS" ]
  ]
}


# Add dependencies to a Cargo.toml manifest file
export extern add [
  dep: string                # Reference to package to add as a dependency
  --no-default-features      # Disable the default features
  --default-features         # Re-enable the default features
  --features(-F): string     # Comma-separated list of features to activate
  --optional                 # Mark the dependency as optional
  --no-optional              # Mark the dependency as required
  --rename: string           # Rename the dependency
  --dry-run                  # Don't write the manifest
  --package: string@packages # Package to modify
  --manifest-path: path      # Path to Cargo.toml

  --path: path               # Filesystem path to local crate to add
  --git: string              # Git repository location
  --branch: string           # Git branch to download crate from
  --tag: string              # Git tag to download crate from
  --rev: string              # Git reference to download crate from
  --registry                 # Package registry for this dependency

  --frozen                   # Require Cargo.lock and cache are up to date
  --locked                   # Require Cargo.lock is up to date
  --offline                  # Run without accessing the network

  --dev                      # Add package as development dependency
  --build                    # Add package as build dependency
  --target: string           # Add packages to this target platform

  --color: string@color      # Set coloring
  --config-file: path        # Config file [default: workspace-root/.config/nextest.toml]
  -Z: string                 # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details

  --quiet(-q)                # Do not print cargo log messages
  --verbose(-v)              # Use verbose output (-vv very verbose/build.rs output)
  --help(-h)                 # Print help information
]

def deny [] {
  [
    { value: "unmaintained", description: "Depenedency is unmaintained" }
    { value: "unsound", description: "Dependency is unsound" }
    { value: "warnings", description: "All deny reasons" }
    { value: "yanked", description: "Dependency is yanked" }
  ]
}

# Audit Cargo.lock files for vulnerable crates
export extern audit [
  --color(-c): string@color # Color configuration
  --db(-d): path            # Advisory database git repo path
  --deny(-D): string@deny   # Exit with an error
  --file(-f): path          # Cargo lockfile to inspect
  --ignore: string          # Advisory ID to ignore
  --ignore-source           # Ignore sources of packages in Cargo.toml
  --no-fetch(-f)            # Do not perform a git fetch on the advisory database
  --stale                   # Allow stale database
  --target-arch: string     # Filter vulnerabilities by CPU
  --target-os: string       # Filter vulnerabilities by OS
  --url(-u): string         # URL for advisory database git repository
  --quiet(-q)               # Do not print cargo log messages
  --json                    # Output report in JSON format
  --version(-V)             # Print version
]

# Automatically upgrade vulnerable dependencies
export extern "audit fix" [
  --file(-f): path # Cargo lockfile to inspect
  --dry-run        # Perform a dry run for the fix
  --version(-V)    # Print version
]

# Compile a local package and all of its dependencies
export extern build [
  --all-features                 # Activate all available features
  --all-targets                  # Build all targets
  --bench: string                # Build only the specified bench target
  --benches                      # Build all benches
  --bin: string                  # Build only the specified binary
  --bins                         # Build all binaries
  --build-plan                   # Output the build plan in JSON (unstable)
  --color: string@color          # When to color output
  --config: string               # Override a configuration value (unstable)
  --example: string              # Build only the specified example
  --examples                     # Build all examples
  --exclude: string              # Exclude packages from the build
  --features: string             # Space or comma separated list of features to activate
  --frozen                       # Require Cargo.lock and cache are up to date
  --future-incompat-report       # Outputs a future incompatibility report at the end of the build
  --help(-h)                     # Print help information
  --ignore-rust-version          # Ignore `rust-version` specification in packages
  --jobs(-j): number             # Number of parallel jobs, defaults to                                    # of CPUs
  --keep-going                   # Do not abort the build as soon as there is an error (unstable)
  --lib                          # Build only this package's library
  --locked                       # Require Cargo.lock is up to date
  --manifest-path: path          # Path to Cargo.toml
  --message-format: string       # Error format
  --no-default-features          # Do not activate the `default` feature
  --offline                      # Run without accessing the network
  --out-dir: path                # Copy final artifacts to this directory (unstable)
  --package(-p): string@packages # Package to build (see `cargo help pkgid`)
  --profile: string              # Build artifacts with the specified profile
  --quiet(-q)                    # Do not print cargo log messages
  --release(-r)                  # Build artifacts in release mode, with optimizations
  --target-dir: path             # Directory for all generated artifacts
  --target: string               # Build for the target triple
  --test: string                 # Build only the specified test target
  --tests                        # Build all tests
  --timings: string@timing       # Timing output formats (unstable, comma separated)
  --unit-graph                   # Output build graph in JSON (unstable)
  --verbose(-v)                  # Use verbose output (-vv very verbose/build.rs output)
  --workspace                    # Build all packages in the workspace
  -Z: string                     # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

# Check a local package and its dependencies for errors
export extern check [
  --ignore-rust-version      # Ignore `rust-version` specification in packages
  --future-incompat-report   # Outputs a future incompatibility report at the end of the build
  --message-format: string   # Error format
  --verbose(-v)              # Use verbose output
  --quiet(-q)                # Do not print cargo log messages
  --color: string@color      # Coloring: auto, always, never
  --config: string           # Override a configuration value
  -Z: string                 # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --package: string@packages # Package to modify
  --workspace                # Build all packages in the workspace
  --exclude: string          # Exclude packages from the build
  --lib                      # Check only this package's library
  --bins                     # Check all binaries
  --bin: string              # Check only the specified binary
  --examples                 # Check all examples
  --example: string          # Check only the specified example
  --tests                    # Check all test targets
  --test: string             # Check only the specified test targets
  --benches                  # Check all bench targets
  --bench: string            # Check only the specified bench targets
  --all-targets              # Check all targets
  --features: string         # Space or comma separated list of features to activate
  --all-features             # Activate all available features
  --no-default-features      # Do not activate the `default` feature
  --jobs(-j): int            # Number of parallel jobs, defaults to of CPUs.
  --keep-going               # Do not abort the build as soon as there is an error (unstable)
  --profile: string          # Install artifacts with the specified profile
  --target: string           # Build for the target triple
  --target-dir: path         # Directory for all generated artifacts
  --unit-graph               # Output build graph in JSON (unstable)
  --timings: string@timing   # Timing output formats (unstable, comma separated)
  --manifest-path: path      # Path to Cargo.toml
  --locked                   # Require Cargo.lock is up to date
  --frozen                   # Require Cargo.lock and cache are up to date
  --offline                  # Run without accessing the network
]

export extern clean [
  --color: string@color          # When to color output
  --config: string               # Override a configuration value (unstable)
  --doc                          # Clean just the documentation directory
  --dry-run                      # Display what would be cleaned without deleting anything
  --frozen                       # Require Cargo.lock and cache are up to date
  --locked                       # Require Cargo.lock is up to date
  --manifest-path: path          # Path to Cargo.toml
  --offline                      # Run without accessing the network
  --package(-p): string@packages # Package to build (see `cargo help pkgid`)
  --profile: string              # Build artifacts with the specified profile
  --quiet(-q)                    # Do not print cargo log messages
  --release(-r)                  # Build artifacts in release mode, with optimizations
  --target-dir: path             # Directory for all generated artifacts
  --target: string               # Build for the target triple
  --verbose(-v)                  # Use verbose output (-vv very verbose/build.rs output)
  -Z: string                     # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

# Checks a package to catch common mistakes and improve your Rust code
export extern clippy [
  --all-features             # Activate all available features
  --all-targets              # Check all targets
  --bench: string            # Check only the specified bench targets
  --benches                  # Check all bench targets
  --bin: string              # Check only the specified binary
  --bins                     # Check all binaries
  --color: string@color      # Coloring: auto, always, never
  --config: string           # Override a configuration value
  --example: string          # Check only the specified example
  --examples                 # Check all examples
  --exclude: string          # Exclude packages from the build
  --explain                  # Print the documentation for a lint
  --explain: string          # Print the documentation for the given lint
  --features: string         # Space or comma separated list of features to activate
  --fix                      # Automatically apply lint suggestions
  --frozen                   # Require Cargo.lock and cache are up to date
  --future-incompat-report   # Outputs a future incompatibility report at the end of the build
  --ignore-rust-version      # Ignore `rust-version` specification in packages
  --jobs(-j): int            # Number of parallel jobs, defaults to of CPUs.
  --keep-going               # Do not abort the build as soon as there is an error (unstable)
  --lib                      # Check only this package's library
  --locked                   # Require Cargo.lock is up to date
  --manifest-path: path      # Path to Cargo.toml
  --message-format: string   # Error format
  --no-default-features      # Do not activate the `default` feature
  --no-deps                  # Run clippy only on the given crate
  --offline                  # Run without accessing the network
  --package: string@packages # Package to modify
  --profile: string          # Install artifacts with the specified profile
  --quiet(-q)                # Do not print cargo log messages
  --target-dir: path         # Directory for all generated artifacts
  --target: string           # Build for the target triple
  --test: string             # Check only the specified test targets
  --tests                    # Check all test targets
  --timings: string@timing   # Timing output formats (unstable, comma separated)
  --unit-graph               # Output build graph in JSON (unstable)
  --verbose(-v)              # Use verbose output
  --version(-V)              # Print version information
  --workspace                # Build all packages in the workspace
  -Z: string                 # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

# Build a package's documentation
export extern doc [
  --open                         # Opens the docs in a browser after the operation
  --no-deps                      # Don't build documentation for dependencies
  --document-private-items       # Document private items
  --message-format: string       # Error format
  --verbose(-v)                  # Use verbose output (-vv very verbose/build.rs output)
  --quiet(-q)                    # Do not print cargo log messages
  --color: string@color          # When to color output
  --config: string               # Override a configuration value
  --package(-p): string@packages # Package to document
  --workspace                    # Build all packages in the workspace
  --exclude: string              # Exclude packages from build
  --lib                          # Document only this package's library
  --bins                         # Document all binaries
  --bin: string                  # Document only the specified binary
  --examples                     # Document all examples
  --example: string              # Document only the specified example
  --jobs(-j): int                # Number of parallel jobs, defaults to of CPUs.
  --keep-going                   # Do not abort the build as soon as there is an error
  --release(-r)                  # Build artifacts in release mode, with optimizations
  --profile: string              # Build artifacts with the specified profile
  --target-dir: path             # Directory for all generated artifacts
  --target: string               # Build for the target triple
  --unit-graph                   # Output build graph in JSON (unstable)
  --timings: string@timing       # Timing output formats (unstable, comma separated)
  --manifest-path: path          # Path to Cargo.toml
  --lockfile-path: path          # Path to Cargo.lock
  --ignore-rust-version          # Ignore `rust-version` specification in packages
  --locked                       # Assert that `Cargo.lock` will remain unchanged
  --offline                      # Run without accessing the network
  --frozen                       # Equivalent to both --locked and --offline
]

# Create a new cargo package in an existing directory
export extern init [
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
export extern install [
  ...spec: string          # Crate to install
  --quiet(-q)              # Do not print cargo log messages
  --version: string        # Specify a version to install
  --git: string            # Git URL to install the specified crate from
  --branch: string         # Branch to use when installing from git
  --tag: string            # Tag to use when installing from git
  --rev: string            # Specific commit to use when installing from git
  --path: path             # Filesystem path to local crate to install
  --list                   # List all installed packages
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

# List all installed packages
export def "install --list" [] {
  ( list_installed
  | sort-by package version
  )
}

# Profile a binary with Xcode Instruments
export extern "instruments" [
  --all-features                 # Activate all available features
  --bench: string                # Check only the specified bench targets
  --bin: string                  # Check only the specified binary
  --example: string              # Check only the specified example
  --features: string             # Space or comma separated list of features to activate
  --list-templates(-l)           # List available templates
  --manifest-path: path          # Path to Cargo.toml
  --no-default-features          # Do not activate the `default` feature
  --no-open                      # Do not open the trace file in Instruments
  --output(-o): path             # Trace file output location
  --package(-p): string@packages # Package to build (see `cargo help pkgid`)
  --profile: string              # Build artifacts with the specified profile
  --release                      # Build artifacts in release mode, with optimizations
  --template(-t): string         # The template to run
  --time-limit: int              # Limit recording time to this many milliseconds
  --version(-V)                  # Print version
  ...args: string                # Arguments passed to the target binary
]

# Find unused dependencies
export extern machete [
  --fix             # Rewrite Cargo.toml to remove unused dependencies
  --no-ignore       # Also search ignored files
  --skip-target-dir # Don't examine target/ directories
  --version         # Print version
  --with-metadata   # Use cargo-metadata to figure out dependency names
  ...paths: path    # Crates to examine
]

# Create a new cargo package
export extern new [
  path: path               # Location of the new package
  --bin                    # Use a binary (application) template [default]
  --color: string@color    # When to color output
  --config: string         # Override a configuration value
  --edition string@edition # Edition to use for the crate generated
  --frozen                 # Require Cargo.lock and cache are up to date
  --lib                    # Use a library template
  --locked                 # Require Cargo.lock is up to date
  --name string            # Package name
  --offline                # Run without accessing the network
  --quiet                  # Do not print cargo log messages
  --registry string        # Registry to use
  --vcs: string@vcs        # Initialize repository for this version control system
  --verbose(-v)            # Use verbose output
  -Z: string               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

# A next-generation test runner
export extern nextest [
  --color: string@color    # When to color output
  --config-file: path      # Config file [default: workspace-root/.config/nextest.toml]
  --help(-h)               # Print help information
  --manifest-path: path    # Path to Cargo.toml
  --verbose(-v)            # Use verbose output
  --version(-V)            # Print version information
]

def nextest_ignore [] {
  ["default", "ignored-only", "all"]
}

def nextest_list_message_format [] {
  ["human", "json", "json-pretty"]
}

# List tests in the workspace
export extern "nextest list" [
  --all-features                 # Activate all available features
  --all-targets                  # Test all targets
  --bench: string                # Test only the specified bench target
  --benches                      # Test all benches
  --bin: string                  # Test only the specified binary
  --bins                         # Test all binaries
  --build-jobs: number           # Number of jobs to run
  --cargo-profile: string        # Build artifacts with the specified Cargo profile
  --color: string@color          # When to color output
  --config-file: path            # Config file [default: workspace-root/.config/nextest.toml]
  --config: string               # Override a configuration value (unstable)
  --exclude: string              # Exclude packages from the build
  --features: string             # Space or comma separated list of features to activate
  --frozen                       # Require Cargo.lock and cache are up to date
  --future-incompat-report       # Outputs a future incompatibility report at the end of the build
  --help(-h)                     # Print help information
  --ignore-rust-version          # Ignore "rust-version" specification in packages
  --lib                          # Test only library unit tests
  --locked                       # Require Cargo.lock is up to date
  --manifest-path: path          # Path to Cargo.toml
  --message-format(-T): string@nextest_list_message_format # Output format
  --no-default-features          # Do not activate the "default" feature
  --offline                      # Run without accessing the network
  --package(-p): string@packages # Package to test
  --partition: string            # Test partition, e.g. hash:1/2 or count:2/3
  --release                      # Build artifacts in release mode, with optimizations
  --run-ignored: string@nextest_ignore # Run ignored tests
  --target-dir: path             # Directory for all generated artifacts
  --target: string               # Build for the target triple
  --test: string                 # Test only the specified test target
  --tests                        # Test all targets
  --unit-graph                   # Output build graph in JSON (unstable)
  --verbose(-v)                  # Use verbose output
  --workspace                    # Build all packages in the workspace
  -Z: string                     # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

def nextest_run_message_format [] {
  [
    { value: "human", description: "Default output format" },
    { value: "libtest-json", description: "libtest format" },
    { value: "libtest-json-plus", description: "libtest format with extra metadata" },
  ]
}

def nextest_archive_format [] {
  ["auto", "tar-zst"]
}

def nextest_output [] {
  ["immediate", "immediate-final", "final", "never"]
}

def nextest_status_level [] {
  ["none", "fail", "retry", "slow", "pass", "skip", "all"]
}

def nextest_timings [] {
  ["html", "json"]
}

# Build and run tests
export extern "nextest run" [
  filter?: string                   # Test name filter
  --all-features                    # Activate all available features
  --all-targets                     # Test all targets
  --archive-file: path              # Path to nextest archive
  --archive-format: string@nextest_archive_format # Archive format
  --bench: string                   # Test only the specified bench target
  --benches                         # Test all benches
  --bin: string                     # Test only the specified binary
  --binaries-metadata: path         # Path to binaries-metadata JSON
  --bins                            # Test all binaries
  --build-jobs: number              # Number of jobs to run
  --cargo-metadata: path            # PAth to cargo metadata JSON
  --cargo-profile: string           # Build artifacts with the specified Cargo profile
  --cargo-quiet                     # Do not print  cargo log messages
  --cargo-verbose                   # Use cargo verbose output
  --color: string@color             # When to color output
  --config-file: path               # Config file [default: workspace-root/.config/nextest.toml]
  --config: string                  # Override a configuration value
  --exclude: string                 # Exclude packages from the build
  --extract-to: path                # Archive extraction directory
  --extract-overwrite               # Overwrite when extracting acrhive
  --fail-fast                       # Cancel test run on the first failure
  --failure-output: string@nextest_output # Output stdout and stderr on failure
  --features: string                # Space or comma separated list of features to activate
  --final-status-level: string@nextest_status_level # Test statuses to output at the end of the run
  --frozen                          # Require Cargo.lock and cache are up to date
  --future-incompat-report          # Outputs a future incompatibility report at the end of the build
  --hide-progress-bar               # Do not display the progress bar
  --ignore-rust-version             # Ignore "rust-version" specification in packages
  --lib                             # Test only library unit tests
  --locked                          # Require Cargo.lock is up to date
  --manifest-path: path             # Path to Cargo.toml
  --message-format: string@nextest_run_message_format # Format to use for test results
  --message-format-version: number  # Version of message-format to use
  --no-capture                      # Run tests serially and do not capture output
  --no-default-features             # Do not activate the "default" feature
  --no-fail-fast                    # Run all tests regardless of failure
  --offline                         # Run without accessing the network
  --override-version-check          # Override checks for the minimum version in the nextest config
  --package(-p): string@packages    # Package to test
  --partition: string               # Test partition, e.g. hash:1/2 or count:2/3
  --persist-extract-tempdir         # Persist extracted temporary directory
  --profile(-P): string             # Nextest profile to use
  --release                         # Build artifacts in release mode, with optimizations
  --retries: number                 # Number of retries for failing tests
  --run-ignored: string@nextest_ignore # Run ignored tests
  --status-level: string@nextest_status_level # Test statuses to output
  --success-output: string@nextest_output # Output stdout and stderr on success
  --target-dir: path                # Directory for all generated artifacts
  --target-dir-remap: path          # Remapping for the target directory
  --target: string                  # Build for the target triple
  --test-threads(-j): number        # Simultaneous threads to run
  --test: string                    # Test only the specified test target
  --tests                           # Test all targets
  --timings: string@nextest_timings # Timing output formats
  --tool-config-file: path          # Tool-specific config files
  --unit-graph                      # Output build graph in JSON (unstable)
  --verbose(-v)                     # Use verbose output
  --workspace                       # Build all packages in the workspace
  --workspace-remap: path           # Remapping for the workspace root
  -Z: string                        # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

# Show information about nextest's configuration in this workspace
export extern "nextest show-config" [
  --color: string@color      # When to color output
  --config-file: path        # Config file [default: workspace-root/.config/nextest.toml]
  --manifest-path: path      # Path to Cargo.toml
  --override-version-check   # Override checks for the minimum version in nextest's config
  --tool-config-file: path   # Tool-specific config files
  --verbose(-v)              # Use verbose output
]

# Show version-related configuration
export extern "nextest show-config version" [
  --color: string@color      # When to color output
  --config-file: path        # Config file [default: workspace-root/.config/nextest.toml]
  --manifest-path: path      # Path to Cargo.toml
  --override-version-check   # Override checks for the minimum version in nextest's config
  --tool-config-file: path   # Tool-specific config files
  --verbose(-v)              # Use verbose output
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

# Information about project dependency versions
export def outdated [
  --aggressive(-a)                # Ignore channels for latest updates
  --depth(-d): number             # How deep in the dependency chain to search
  --exclude(-e): string           # comma-separated list of dependencies to exclude from building
  --exit-code: number             # Exit code to return when new versions are found
  --features: string              # Space-separated list of features
  --ignore(-i): string            # comma-separated list of dependencies to ignore
  --ignore-external-rel(-e)       # Ignore relative dependencies external to the workspace and check root dependencies only
  --manifest-path: path           # Path to Cargo.toml
  --offline(-o)                   # Run without accessing the network
  --packages(-p): string@packages # Package to inspect for updates
  --root(-r): path                # Package to treat as the root package
  --root-deps-only(-R)            # Only check root dependencies
  --quiet(-q)                     # Do not print cargo log messages
  --verbose(-v)                   # Use verbose output
  --version(-V)                   # Print version
  --workspace(-w)                 # Check updates for all workspace members
] {
  if $version {
    let version = run-external "cargo" "outdated" "--version"

    return $version
  }

  mut args = []

  if $aggressive {
    $args = ( $args | append "--aggressive" )
  }

  if $depth != null {
    $args = ( $args | append [ "--depth" $depth ] )
  }

  if $exclude != null {
    $args = ( $args | append [ "--exclude" $exclude ] )
  }

  if $exit_code != null {
    $args = ( $args | append [ "--exit-code" $exit_code ] )
  }

  if $features != null {
    $args = ( $args | append [ "--features" $features ] )
  }

  if $ignore != null {
    $args = ( $args | append [ "--ignore" $ignore ] )
  }

  if $ignore_external_rel {
    $args = ( $args | append "--ignore-external-rel" )
  }

  if $manifest_path != null {
    $args = ( $args | append [ "--manifest-path" $manifest_path ] )
  }

  if $offline {
    $args = ( $args | append "--offline" )
  }

  if $packages != null {
    $args = ( $args | append [ "--packages" $packages ] )
  }

  if $root != null {
    $args = ( $args | append [ "--root" $root ] )
  }

  if $root_deps_only {
    $args = ( $args | append "--root-deps-only" )
  }

  if $quiet {
    $args = ( $args | append "--quiet" )
  }

  if $verbose {
    $args = ( $args | append "--verbose" )
  }

  if $workspace {
    $args = ( $args | append "--workspace" )
  }

  run-external "cargo" "outdated" "--format" "json" ...$args
  | lines
  | each {|l|
    $l | from json
  }
}

# Remove a rust binary
export extern uninstall [
  ...spec: string@installed      # Binary to remove
  --quiet(-q)                    # Do not print cargo log messages
  --package(-p): string@packages # Package to uninstall
  --bin: string                  # Only uninstall the binary NAME
  --root: path                   # Directory to uninstall packages from
  --help(-h)                     # Print help
  --verbose(-v)                  # Use verbose output (-vv very verbose/build.rs output)
  --color: string@color          # Coloring: auto, always, never
  --frozen                       # Require Cargo.lock and cache are up to date
  --locked                       # Require Cargo.lock is up to date
  --offline                      # Run without accessing the network
  --config: string               # Override a configuration value
  -Z: string                     # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

# Update dependencies as recorded in the local lock file
export extern update [
  ...spec: string@list_dependencies # Packages to update
  --color: string@color             # Coloring: auto, always, never
  --config: string                  # Override a configuration value
  --dry-run                         # Perform a dry run for the fix
  --frozen                          # Require Cargo.lock and cache are up to date
  --help(-h)                        # Print help
  --locked                          # Require Cargo.lock is up to date
  --manifest-path: path             # Path to Cargo.toml
  --offline                         # Run without accessing the network
  --precise: string                 # Update [SPEC] to exactly PRECISE
  --quiet(-q)                       # Do not print cargo log messages
  --recursive                       # Force updating all dependencies of [SPEC]... as well
  --verbose(-v)                     # Use verbose output (-vv very verbose/build.rs output)
  --workspace                       # Build all packages in the workspace
  -Z: string                        # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

