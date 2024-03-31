# brew

# The Missing Package Manager for macOS (or Linux)
export extern main [
  --cache      # Display Homebrew's download cache
  --caskroom   # Display Homebrew's Caskroom path
  --cellar     # Display Homebrew's Cellar path
  --env        # Summarize Homebrew's build environment
  --prefix     # Display Homebrew's install path
  --repository # Display where Homebrew's git repository is located
  --version    # Brew version
]

# Install a formula
export extern "brew install" [
  ...formula: string             # Formulae to install
  --HEAD                         # Install the HEAD version, if available
  --adopt                        # Adopt existing artifacts in the destination that are identical to those being installed
  --appdir: string               # Target location for Applications
  --audio-unit-plugindir: string # Target location for Audio Unit Plugins
  --binaries                     # Enable linking of helper executables (default)
  --bottle-arch: string          # Optimize bottles for the specified architecture
  --build-bottle                 # Prepare the formulae for eventual bottling
  --build-from-source(-s)        # Compile from source even if a bottle is provided
  --cask                         # Treat all named arguments as casks
  --casks                        # Treat all named arguments as casks
  --cc: string                   # Attempt to compile the formulae
  --colorpickerdir: string       # Target location for Color Pickers
  --debug(-d)                    # Open interactive debugging session if brewing fails
  --debug-symbols                # Generate debug symbols on build
  --dictionarydir: string        # Target location for Dictionaries
  --display-times                # Print install times for the package
  --dry-run(-n)                  # Show what would be installed
  --fetch-HEAD                   # Fetch the upstream repository to see if the HEAD installation is outdated
  --fontdir: string              # Target location for Fonts
  --force(-f)                    # Install formulae without checking for previously installed key-only or non-migrated versions
  --force-bottle                 # Install from a bottlee even if it would not normally be used
  --formula                      # Treat all named arguments as forumlae
  --formulae                     # Treat all named arguments as forumlae
  --git(-g)                      # Create a homebrew Git repository, useful for creating patches
  --ignore-dependencies          # Skip installing dependencies of any kind (unsupported)
  --include-test                 # Install testing dependencies necessary for `brew test`
  --input-methoddir: string      # Target location for Input Methods
  --interactive(-i)              # Download and patch the formulae, then open a shell
  --internet-plugindir: string   # Target location for Internet Plugins
  --keep-tmp                     # Reatin temporary files created during installation
  --keyboard-layoutdir: string   # Target location for Keyboard Layouts
  --language: string             # Comma-separated list of language codes to prefer
  --mdimporterdir: string        # Target location for Spotlight Plugins
  --no-binaries                  # Disable linking of helper executables
  --no-quarantine                # Disable quarantining of downloads
  --only-dependencies            # Install formulae dependencies but not the name forumlae
  --overwrite                    # Delete files that already exist in the prefix when linking
  --prefpanedir: string          # Target location for Preference Panes
  --qlplugindir: string          # Target location for Quick Look Plugins
  --quarantine                   # Enable quarantining of downloads (default)
  --quiet                        # Make some output more quiet
  --require-sha                  # Require all casks to have a checksum
  --screen-saverdir: string      # Target location for Screen Savers
  --servicedir: string           # Target location for Services
  --skip-cask-deps               # Skip installing cask dependencies
  --skip-post-install            # Skip post-install steps
  --verbose(-v)                  # Print verification and post-install steps
  --vst-plugindir: string        # Target location for VST Plugins
  --vst3-plugindir: string       # Target location for VST3 Plugins
  --zap                          # Remove all files associated with a cask
]

# List all installed formulae
export extern "brew list" [
  ...formulae: string
  --cask        # Treat all named arguments as casks
  --casks       # Treat all named arguments as casks
  --debug(-d)   # Display any debugging information
  --formula     # Treat all named arguments as forumlae
  --formulae    # Treat all named arguments as forumlae
  --full-name   # Print formulae with fully-qualified names
  --multiple    # Only show forumlae with multiple versions installed
  --pinned      # List only pinned formulae
  --quiet(-q)   # Make some output more quiet
  --verbose(-v) # Make some output more verbose
  --versions    # Show versions for installed formulae
  -1            # Force output to be one entry per line
  -l            # List formulae in long format
  -r            # Reverse the order of formulae (oldest first)
  -t            # Order formulae by modified time
]

export extern "brew search" [
  ...substring: string # Substring to search for
  --archlinux          # Search for text in ArchLinux
  --cask               # Search for casks
  --casks              # Search for casks
  --closed             # Search for only closed GitHub pull requests
  --debian             # Search for text in Debian
  --debug(-d)          # Display any debugging information
  --desc               # Search for formulae with a description matching text and casks with a name or description matching text
  --eval-all           # Evaluate all available formulae and casks, whether installed or not
  --fedora             # Search for text in Fedora
  --fink               # Search for text in Fink
  --formula            # Search for formulae
  --formulae           # Search for formulae
  --macports           # Search for text in Macports
  --open               # Search for only open GitHub pull requests
  --opensuse           # Search for text in OpenSUSE
  --pull-request       # Search for GitHub pull requests containing text
  --quiet(-q)          # Make some output more quiet
  --repology           # Search for text in Repology
  --ubuntu             # Search for text in Ubuntu
  --verbose(-v)        # Make some output more verbose
]

# Uninstall a formula
export extern "brew uninstall" [
  ...formulae: string   # Formulae to uninstall
  --cask                # Treat all named arguments as casks
  --casks               # Treat all named arguments as casks
  --debug(-d)           # Display any debugging information
  --force(-f)           # Delete all installed versions of formula
  --formula             # Treat all named arguments as formulae
  --formulae            # Treat all named arguments as formulae
  --ignore-dependencies # Don't fail uninstall, even if formula is a dependency of any installed formulae
  --quiet(-q)           # Make some output more quiet
  --verbose(-v)         # Make some output more verbose
  --zap                 # Remove all files associated with a cask
]

