# atuin

# Magical shell history
export extern main [] {
}

# Manipulate shell history
export extern history []

# Begins a new command in the history
export extern "history start" [
  command: string # Command to add
]

# Finishes a new command in the history (adds time, exit code)
export extern "history end" [
  --exit(-e): int     # Exit code
  --duration(-d): int # Command duration
  id: int             # Command start ID
]

# List all items in history
export extern "history list" [
  --cmd-only           # Show only the text of the command
  --cwd(-c)            # Show history for the current directory
  --format(-f): string # Format output
  --human              # Human-friendly output
  --print0             # Terminate output with a null
  --reverse(-r)        # Reverse output order
  --session(-s)        # Show history for the current session
]

# Get the last command ran
export extern "history last" [
  --cmd-only           # Show only the text of the command
  --format(-f): string # Format output
  --human              # Human-friendly output
]

# Delete history entries matching exclusion filters
export extern "history prune" [
  --dry-run # List matching history lines without deleting
]

# Import shell history from file
export extern import []

# Import history for the current shell
export extern "import auto" []

# Import history from the zsh history file
export extern "import zsh" []

# Import history from the zsh history file
export extern "import zsh-hist-db" []

# Import history from the bash history file
export extern "import bash" []

# Import history from the resh history file
export extern "import resh" []

# Import history from the fish history file
export extern "import fish" []

# Import history from the nu history file
export extern "import nu" []

# Import history from the nu history file
export extern "import nu-hist-db" []

# Calculate statistics for your history
export extern stats [
  --count: int   # Number of top commands
  period?: string # Statistics period
]

def filter_mode [] {
  [
    [ value description ];
    [ directory "History from the current directory" ]
    [ global "Global history" ]
    [ host "History from the current host" ]
    [ session "History for the current session" ]
    [ workspace "History for the current workspace" ]
  ]
}

def search_mode [] {
  [
    [ value description ];
    [ prefix "Prefix search" ]
    [ full-text "Full-text search" ]
    [ fuzzy "Fuzzy search" ]
    [ skim "Skim search" ]
  ]
}

# Interactive history search
export extern search [
  --after: datetime                 # Only includes results after this date
  --before(-b): datetime            # Only include results added before this date
  --cmd-only                        # Show only the text of the command
  --cwd(-c)                         # Filter search to the current directory
  --cwd(-c): path                   # Filter search to the given directory
  --delete                          # Delete history matching this query
  --delete-it-all                   # Delete EVERYTHING!
  --exclude-cwd: path               # Exclude directory from results
  --exclude-exit: int               # Exclude results with this exit code
  --exit(-e): int                   # Filter search result by exit code
  --filter-mode: string@filter_mode # Override filter mode
  --format(-f): string              # Format output
  --human                           # Use human-readable time formats
  --inline-height: int              # Maximum number of lines in the search interface
  --interactive(-i)                 # Open interactive search UI
  --limit: int                      # How many entries to return
  --reverse(-r)                     # Reverse order, oldest first
  --search-mode: string@search_mode # Override search mode
]

# Sync with the configured server
export extern sync [
  --force(-f) # Force re-download everything
]

# Login to the configured server
export extern login [
  --username(-u): string # Username
  --password(-p): string # Password
  --key(-k): string      # Account encryption key
]

# Log out
export extern logout []

# Register with the configured server
export extern register [
  --username(-u): string # Username
  --password(-p): string # Password
  --email(-e): string    # Email
]

# Print the synchronization encryption key
export extern key [
  --base64 # Base64 encode output
]

# Print status
export extern status [
]

export extern account []

export extern kv []

# Print example configuration
export extern default-config []

# Start an server
export extern server []

# Output shell setup
export extern init []

# Generate a UUID
export extern uuid []

# List contributors
export extern contributors []

# Generate shell completions
export extern gen-completions []

