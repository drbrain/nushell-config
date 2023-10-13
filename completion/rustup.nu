use wrapper rustup *

def commands [] {
  [
    { value: "check", description: "Check for updates to Rust toolchains and rustup" },
    { value: "completions", description: "Generate completion scripts for your shell" },
    { value: "component", description: "Modify a toolchain's installed components" },
    { value: "default", description: "Set the default toolchain" },
    { value: "doc", description: "Open the documentation for the current toolchain" },
    { value: "help", description: "Print this message or the help of the given subcommand" },
    { value: "man", description: "View the man page for the given command" },
    { value: "override", description: "Modify directory toolchain overrides" },
    { value: "run", description: "Run a command with an environment configured for the given toolchain" },
    { value: "self", description: "Modify the rustup installation" },
    { value: "set", description: "Alter rustup settings" },
    { value: "show", description: "Show the active and installed toolchains or profiles" },
    { value: "target", description: "Modify a toolchain's supported targets" },
    { value: "toolchain", description: "Modify or query the installed toolchains" },
    { value: "update", description: "Update rust toolchains and rustup" },
    { value: "which", description: "Dusplay which binary will be run for a given command" },
  ]
}

export extern main [
  --verbose(-v) # Enable verbose output
  --quiet(-q)   # Disable progress output
  --help(-h)    # Print help information
  --version(-V) # Print version information
  subcommand: string@commands
]

def toolchain [] {
  ( list_toolchains
  | get toolchain
  | flatten
  )
}

def toolchain-command [] {
  [
    { value: "help", description: "Print this message or the help of the given subcommand" },
    { value: "install", description: "Install or update a given toolchain" },
    { value: "link", description: "Create a custom toolchain by symlinking a directory" },
    { value: "list", description: "List installed toolchains" },
    { value: "uninstall", description: "Uninstall a toolchain" },
  ]
}

export extern "rustup toolchain" [
  --help(-h) # Print help information
  subcommand: string@toolchain-command
]

def profile [] {
  [
    { value: "minimal", description: "Minimal components for a working compiler (rustc, rust-std, cargo)" },
    { value: "default", description: "Default components (rustc, rust-std, rust-docs, cargo, rustfmt, clippy)" },
    { value: "complete", description: "All components" },
  ]
}

export extern "rustup toolchain install" [
  --profile: string@profile # Component group to install
  --component(-c): string   # Add specific components on installation
  --target(-t): string      # Add specific targets on installation
  --no-self-update          # Don't perform self update when running the`rustup toolchain install` command
  --force                   # Force an update, even if some components are missing
  --allow-downgrade         # Allow rustup to downgrade the toolchain to satisfy your component choice
  --force-non-host          # Install toolchains that require an emulator. See https://github.com/rust-lang/rustup/wiki/Non-host-toolchains
  --help(-h)                # Print help information
  ...toolchain: string      # Toolchain to install
]

export extern "rustup toolchain link" [
  --help(-h)           # Print help information
  toolchain: string    # Custom toolchain name
  path: string         # Path to toolchain directory
]

export extern "rustup toolchain uninstall" [
  --help(-h)                  # Print help information
  toolchain: string@toolchain # Toolchain to uninstall
]

export def "rustup toolchain list" [
  --verbose(-v) # Enable verbose output (always enabled)
  --help(-h)    # Print help information
] {
  list_toolchains
}
