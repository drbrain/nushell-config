# fastly
#
# https://www.fastly.com/documentation/reference/cli/

# A tool to interact with the fastly API
export extern main []

export extern "update" [
  --accept-defaults(-d) # Accept default options except yes/no confirmations
  --auto-yes(-d)        # Answer yes to everything
  --debug-mode          # Print API request/response details
  --enable-sso          # Enable SSO
  --non-interactive(-i) # Do not prompt for user input
  --profile(-o): string # Switch account profile
  --quiet(-q)           # Silence all output except interactive prompts
  --token(-t): string   # Fastly API token
  --verbose(-v)         # Verbose logging
]

export extern "compute build" [
  --dir(-C): path                   # Project directory
  --env: string                     # The manifest environment config to use
  --include-source                  # Include source in built package
  --language: string                # Language type
  --metadata-disable                # Disable Wasm binary metadata annotations
  --metadata-filter-envvars: string # Redact specified environment variables
  --metadata-show                   # Inspect Wasm binary metadata
  --timeout: int                    # Timeout for build compilation (seconds)

  --accept-defaults(-d) # Accept default options except yes/no confirmations
  --auto-yes(-d)        # Answer yes to everything
  --debug-mode          # Print API request/response details
  --enable-sso          # Enable SSO
  --non-interactive(-i) # Do not prompt for user input
  --profile(-o): string # Switch account profile
  --quiet(-q)           # Silence all output except interactive prompts
  --token(-t): string   # Fastly API token
  --verbose(-v)         # Verbose logging
]

export extern "compute deploy" [
  --service-id(-s): string    # Service ID
  --service-id(-s): string    # Service ID
  --service-name: string      # Service name
  --service-name: string      # Service name
  --version: string           # Fastly service version, 'active', 'latest'
  --comment: string           # Deployment comment
  --dir(-C): path             # Project directory
  --domain: string            # Domain associated with the package
  --package(-p): path         # Path to a package tar.gz
  --status-check-code: string # Set the expected status response for the availability check
  --status-check-path: string # URL for the service availability check
  --status-check-timeout: int # Timeout for the service availability check (seconds)
  --env: string               # The manifest environment config to use

  --accept-defaults(-d) # Accept default options except yes/no confirmations
  --auto-yes(-d)        # Answer yes to everything
  --debug-mode          # Print API request/response details
  --enable-sso          # Enable SSO
  --non-interactive(-i) # Do not prompt for user input
  --profile(-o): string # Switch account profile
  --quiet(-q)           # Silence all output except interactive prompts
  --token(-t): string   # Fastly API token
  --verbose(-v)         # Verbose logging
]

export extern "compute init" [
  --author(-a): string   # Package authors
  --directory(-p): path  # Destination directory
  --from(-f): string     # Create project from another project
  --language(-l): string # Package language

  --accept-defaults(-d) # Accept default options except yes/no confirmations
  --auto-yes(-d)        # Answer yes to everything
  --debug-mode          # Print API request/response details
  --enable-sso          # Enable SSO
  --non-interactive(-i) # Do not prompt for user input
  --profile(-o): string # Switch account profile
  --quiet(-q)           # Silence all output except interactive prompts
  --token(-t): string   # Fastly API token
  --verbose(-v)         # Verbose logging
]

export extern "compute serve" [
  --addr: string                    # IP address and port to listen on
  --dir(-C): path                   # Project directory
  --env: string                     # The manifest environment config to use
  --file: path                      # The Wasm file to run
  --include-source                  # Include source in built package
  --language: string                # Language type
  --metadata-disable                # Disable Wasm binary metadata annotations
  --metadata-filter-envvars: string # Redact specified environment variables
  --metadata-show                   # Inspect Wasm binary metadata
  --package-name: string            # Package name
  --profile-guest                   # Profile the Wasm guest
  --profile-guest-dir: path         # Where per-request profiles are saved
  --skip-build                      # Skip the build step
  --viceroy-args: string            # Additional viceroy arguments
  --viceroy-check                   # Force the CLI to check for a newer viceroy
  --viceroy-path: path              # Path to viceroy
  --watch-dir: path                 # The directory to watch files in

  --accept-defaults(-d) # Accept default options except yes/no confirmations
  --auto-yes(-d)        # Answer yes to everything
  --debug-mode          # Print API request/response details
  --enable-sso          # Enable SSO
  --non-interactive(-i) # Do not prompt for user input
  --profile(-o): string # Switch account profile
  --quiet(-q)           # Silence all output except interactive prompts
  --token(-t): string   # Fastly API token
  --verbose(-v)         # Verbose logging
]

export extern "compute update" [
  --service-id(-s): string # Service ID
  --service-name: string   # Service name
  --autoclone              # If the service is not editable clone it and use the clone
  --package(-p): path      # Path to a package tar.gz

  --accept-defaults(-d) # Accept default options except yes/no confirmations
  --auto-yes(-d)        # Answer yes to everything
  --debug-mode          # Print API request/response details
  --enable-sso          # Enable SSO
  --non-interactive(-i) # Do not prompt for user input
  --profile(-o): string # Switch account profile
  --quiet(-q)           # Silence all output except interactive prompts
  --token(-t): string   # Fastly API token
  --verbose(-v)         # Verbose logging
]
