# Homebrew

use wrapper brew *

def installable [context: string] {
  let query = $context | split words | last
  let all = list_casks | append (list_formulae) | sort
  let matches = $all | where {|| $in =~ $query }

  if ( $matches | length ) < 10 {
    $matches
    | each {|item|
      let description = description $item | get desc.0
      
      { value: $item, description: $description }
    }
  } else {
    $matches
  }
}

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

# Uninstall formulae that were installed as a dependency and are no longer
# needed
export extern autoremove [
  --dry-run(-n) # Show what would be removed
]

# List all locally installable casks
export extern casks []

# Remove stale lock files, outdated downloads, old versions
export extern cleanup [
  --dry-run(-n) # Show what would be removed
  --prune-prefix # Only prune the symlinks and directories from the prefix
  --prune: string # Remove all cache files older than this many days, or "all"
  -s # Scribe the cache, including downloads for the latest versions
]

# Show Homebrew and system configuration
export extern config []

# Show dependencies for formulae
export extern deps [
  ...formulae: string@list_installed # Forumlae to show deps for
  --topological(-n) # Show in topological order
  --direct(-1) # Show only direct dependencies
  --union # Show the union of dependencies
  --full-name # List dependencies by their full name
  --include-build # Include build dependencies
  --include-optional # Include optional dependencies
  --include-test # Include test dependencies
  --skip-recommended # Skip recommended dependencies
  --include-requirements # Include requirements in addition to dependencies
  --tree # Show dependencies as a tree
  --graph # Show dependencies as a directed graph
  --dot # Show dependencies in DOT format
  --annotate # Mark build, test, implicit, optional, or recommended dependencies
  --installed # List dependencies for formulae that are currently installed
  --missing # Show only missing dependencies
  --eval-all # Evaluate all available forumale, installed or not, to list their dependencies
  --for-each # Debugging mode for --installed and --eval-all
  --HEAD # Show dependencies for HEAD version
  --forumla # Treat all arguments as formulae
  --cask # Treat all arguments as casks
]

# Display formula's name and one-line description
export extern desc [
  ...search: string # Formulae to show
  --cask            # Treat all named arguments as casks
  --casks           # Treat all named arguments as casks
  --description(-d) # Search only descriptions
  --eval-all        # Evaluate all available forumale and casks to search their descriptions
  --formula         # Treat all named arguments as forumlae
  --formulae        # Treat all named arguments as forumlae
  --name(-n)        # Search only names
  --quiet(-q)       # Make some output more quiet
  --search(-s)      # Search both names and descriptions
  --verbose(-v)     # Print verification and post-install steps
]

# Check your system for potential problems
export extern doctor [
  ...check: string@list_checks # check to run
  --list-checks                # List all audit methods
  --audit-debug(-D)            # Enable debugging and profiling of audit methods

]

# List all locally installable forumlae
export extern formulae []

# Open homepage for a forumlae or casks
export extern home [
  ...formula: string@installable # Formula
  --cask # Treat all argumest as casks
  --formula # Treat all arguments as formulae
]

def info_category [] {
  [
    { value: "build-error" }
    { value: "cask-install" }
    { value: "install", description: "(default)" }
    { value: "install-on-request" }
    { value: "os-version" }
  ]
}

def info_days [] {
  [
    { value: 30, description: "30 days" }
    { value: 90, description: "90 days" }
    { value: 365, description: "365 days" }
  ]
}

# Display information about Homebrew and formulae
export extern info [
  ...formula: string@installable   # Formulae to show information for
  --analytics                      # List global Homebrew analytics or installation and build errors for formulae
  --days: int@info_days            # How many days of analytics to retrieve
  --category                       # Retrieve analytics for the install category
  --category: string@info_category # Category of analytics to retrieve
  --github                         # Open the GitHub source page for formulae
  --json                           # Print a JSON representation
  --installed                      # Print JSON of installed formulae
  --eval-all                       # Evaluate all available formulae and casks, whether installed or not
  --variations                     # Include the variations hash for each forumla
  --verbose(-v)                    # Print verification and post-install steps
  --formula                        # Treat all named arguments as forumlae
  --cask                           # Treat all named arguments as casks
]

# Install a formula
export extern install [
  ...formula: string@installable # Formulae to install
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

# List installed formulae that are not dependencdies of another installed
# formula
export extern leaves [
  --installed-on-request(-r)    # Only list leaves that were manually installed.
  --installed-as-dependency(-p) # Only list leaves that were installed as dependencies.
  --debug(-d)                   # Display any debugging information
  --quiet(-q)                   # Make some output more quiet
  --verbose(-v)                 # Make some output more verbose
]

# List all installed formulae
export extern list [
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

# List installed casks and formulae that have an updated version available
export extern outdated [
  ...formulae: string@list_installed # Formulae to check
  --cask                # Treat all named arguments as casks
  --casks               # Treat all named arguments as casks
  --fetch-HEAD          # Fetch the upstream repository to see if the HEAD installation is outdated
  --formula             # Treat all named arguments as forumlae
  --formulae            # Treat all named arguments as forumlae
  --greedy(-g)          # Include outdated casks with "auto_udpates true" or "version :latest"
  --greedy-auto-updates # Include outdated casks with "auto_updates true"
  --greedy-latest       # Include outdated casks with "version :latest"
  --json                # Print a JSON representation
  --quiet(-q)           # List only the names of outdated keys
  --verbose(-v)         # Include all detailed information
]

export extern search [
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
export extern uninstall [
  ...formulae: string@list_installed # Formulae to uninstall
  --cask                             # Treat all named arguments as casks
  --casks                            # Treat all named arguments as casks
  --debug(-d)                        # Display any debugging information
  --force(-f)                        # Delete all installed versions of formula
  --formula                          # Treat all named arguments as formulae
  --formulae                         # Treat all named arguments as formulae
  --ignore-dependencies              # Don't fail uninstall, even if formula is a dependency of any installed formulae
  --quiet(-q)                        # Make some output more quiet
  --verbose(-v)                      # Make some output more verbose
  --zap                              # Remove all files associated with a cask
]

# Update Homebrew itself
export extern update [
  --merge # Apply updates with `git merge` (default is `git rebase`)
  --auto-update # Run auto-updates
  --force(-f) # Run a slower full update check (even if unnecessary)
]

# Update outdated casks and unpinned formulae
export extern upgrade [
  ...formulae: string@list_outdated # Formulae to upgrade
  --appdir: string                  # Target location for Applications
  --audio-unit-plugindir: string    # Target location for Audio Unit Plugins
  --binaries                        # Enable linking of helper executables (default)
  --build-from-source(-s)           # Compile formula from source even if a bottle is available
  --cask                            # Treat all named arguments as casks
  --casks                           # Treat all named arguments as casks
  --colorpickerdir: string          # Target location for Color Pickers
  --debug(-d)                       # Open an interactive debugging session upon failures
  --debug-symbols                   # Generate debug symbols on build
  --dictionarydir: string           # Target location for Dictionaries
  --display-times                   # Print install times for each package
  --dry-run(-n)                     # Show what would be upgraded, but do not actually upgrade anything
  --fetch-HEAD                      # Fetch the upstream repository to see if the HEAD installation is outdated
  --fontdir: string                 # Target location for Fonts
  --force(-f)                       # Install formulae without checking for previously installed keg-only or non-migrated versions
  --force-bottle                    # Install from a bottle if it exists for the current or newest version of macOS, even if it would not normally be used for installation
  --formula                         # Treat all named arguments as formulae
  --formulae                        # Treat all named arguments as formulae
  --greedy(-g)                      # Include outdated casks with "auto_udpates true" or "version :latest"
  --greedy-auto-updates             # Include outdated casks with "auto_updates true"
  --greedy-latest                   # Include outdated casks with "version :latest"
  --input-methoddir: string         # Target location for Input Methods
  --interactive(-x)                 # Download and patch formula, then open a shell
  --internet-plugindir: string      # Target location for Internet Plugins
  --keep-tmp                        # Retain the temporary files created during installation
  --keyboard-layoutdir: string      # Target location for Keyboard Layouts
  --language: string                # Comma-separated list of language codes to prefer
  --mdimporterdir: string           # Target location for Spotlight Plugins
  --no-binaries                     # Disable linking of helper executables
  --no-quarantine                   # Disable quarantining of downloads
  --overwrite                       # Delete files that already exist in the prefix while linking
  --prefpanedir: string             # Target location for Preference Panes
  --qlplugindir: string             # Target location for Quick Look Plugins
  --quarantine                      # Enable quarantining of downloads (default)
  --quiet                           # Make some output more quiet
  --require-sha                     # Require all casks to have a checksum.
  --screen-saverdir: string         # Target location for Screen Savers
  --servicedir: string              # Target location for Services
  --skip-cask-deps                  # Skip installing cask dependencies
  --verbose(-v)                     # Print the verification and post-install steps
  --vst-plugindir: string           # Target location for VST Plugins
  --vst3-plugindir: string          # Target location for VST3 Plugins
]
