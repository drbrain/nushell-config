use wrapper rustup *

def commands [] {
  [
    [ value description ];
    [ check "Check for updates to Rust toolchains and rustup" ]
    [ completions "Generate completion scripts for your shell" ]
    [ component "Modify a toolchain's installed components" ]
    [ default "Set the default toolchain" ]
    [ doc "Open the documentation for the current toolchain" ]
    [ man "View the man page for the given command" ]
    [ override "Modify directory toolchain overrides" ]
    [ run "Run a command with an environment configured for the given toolchain" ]
    [ self "Modify the rustup installation" ]
    [ set "Alter rustup settings" ]
    [ show "Show the active and installed toolchains or profiles" ]
    [ target "Modify a toolchain's supported targets" ]
    [ toolchain "Modify or query the installed toolchains" ]
    [ update "Update rust toolchains and rustup" ]
    [ which "Display which binary will be run for a given command" ]
  ]
}

# Rustup toolchain installed
export extern main [
  --verbose(-v) # Enable verbose output
  --quiet(-q)   # Disable progress output
  --version(-V) # Print version information
  subcommand: string@commands
]

def installed [] {
  list_toolchains
  | get toolchain
  | flatten
  | append beta
  | append nightly
  | append stable
  | sort
}

def toolchain-command [] {
  [
    [ value description ];
    [ install "Install or update a given toolchain" ]
    [ link "Create a custom toolchain by symlinking a directory" ]
    [ list "List installed toolchains" ]
    [ uninstall "Uninstall a toolchain" ]
  ]
}

# Install, uninstall, list toolchains
export extern toolchain [
  subcommand: string@toolchain-command
]

def profile [] {
  [
    [ value description ];
    [ minimal "Minimal components for a working compiler (rustc, rust-std, cargo)" ]
    [ default "Default components (rustc, rust-std, rust-docs, cargo, rustfmt, clippy)" ]
    [ complete "All components" ]
  ]
}

# Install or update toolchains
export extern "toolchain install" [
  --profile: string@profile # Component group to install
  --component(-c): string   # Add specific components on installation
  --target(-t): string      # Add specific targets on installation
  --no-self-update          # Don't perform self update when running the`rustup toolchain install` command
  --force                   # Force an update, even if some components are missing
  --allow-downgrade         # Allow rustup to downgrade the toolchain to satisfy your component choice
  --force-non-host          # Install toolchains that require an emulator. See https://github.com/rust-lang/rustup/wiki/Non-host-toolchains
  ...toolchain: string      # Toolchain to install
]

# Create a custom toolchain
export extern "toolchain link" [
  toolchain: string    # Custom toolchain name
  path: string         # Path to toolchain directory
]

# Uninstall the given toolchain
export extern "toolchain uninstall" [
  toolchain: string@installed # Toolchain to uninstall
]

# List installed toolchains
export def "toolchain list" [
  --verbose(-v) # Enable verbose output (always enabled)
] {
  list_toolchains
}

# Update Rust toolchains and rustup
export extern "update" [
  --no-self-update            # Don't perform a self update
  --force                     # Force an update, even if some components are missing
  --force-non-host            # Install toolchains that require an emulator
  toolchain: string@installed # Toolchain to uninstall
]
