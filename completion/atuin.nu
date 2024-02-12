# atuin

# Magical shell history
export extern main [] {
}

# Manipulate shell history
export extern "atuin history" []

# Begins a new command in the history
export extern "atuin history start" [
  command: string # Command to add
]

# Finishes a new command in the history (adds time, exit code)
export extern "atuin history end" [
  --exit(-e): int     # Exit code
  --duration(-d): int # Command duration
  id: int             # Command start ID
]

# List all items in history
export extern "atuin history list" [
  --cmd-only           # Show only the text of the command
  --cwd(-c)            # Show history for the current directory
  --format(-f): string # Format output
  --human              # Human-friendly output
  --print0             # Terminate output with a null
  --reverse(-r): bool  # Reverse output order
  --session(-s)        # Show history for the current session
]

# Get the last command ran
export extern "atuin history last" [
  --cmd-only           # Show only the text of the command
  --format(-f): string # Format output
  --human              # Human-friendly output
]

# Import shell history from file
export extern "atuin import" []

# Import history for the current shell
export extern "atuin import auto" []

# Import history from the zsh history file
export extern "atuin import zsh" []

# Import history from the zsh history file
export extern "atuin import zsh-hist-db" []

# Import history from the bash history file
export extern "atuin import bash" []

# Import history from the resh history file
export extern "atuin import resh" []

# Import history from the fish history file
export extern "atuin import fish" []

# Import history from the nu history file
export extern "atuin import nu" []

# Import history from the nu history file
export extern "atuin import nu-hist-db" []

# Calculate statistics for your history
export extern "atuin stats" [
  --count: int   # Number of top commands
  period?: string # Statistics period
]

def filter_mode [] {
  [
    { value: "directory", description: "History from the current directory" }
    { value: "global", description: "Global history" }
    { value: "host", description: "History from the current host" }
    { value: "session", description: "History for the current session" }
    { value: "workspace", description: "History for the current workspace" }
  ]
}

def search_mode [] {
  [
    { value: "prefix", description: "Prefix search" }
    { value: "full-text", description: "Full-text search" }
    { value: "fuzzy", description: "Fuzzy search" }
    { value: "skim", description: "Skim search" }
  ]
}

# Interactive history search
export extern "atuin search" [
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
export extern "atuin sync" [
  --force(-f) # Force re-download everything
]

# Login to the configured server
export extern "atuin login" [
  --username(-u): string # Username
  --password(-p): string # Password
  --key(-k): string      # Account encryption key
]

# Log out
export extern "atuin logout" []

# Register with the configured server
export extern "atuin register" [
  --username(-u): string # Username
  --password(-p): string # Password
  --email(-e): string    # Email
]

# Print the synchronization encryption key
export extern "atuin key" [
  --base64 # Base64 encode output
]

# Print atuin status
export extern "atuin status" [
]

export extern "atuin account" []

export extern "atuin kv" []

# Print example configuration
export extern "atuin default-config" []

# Start an atuin server
export extern "atuin server" []

# Output shell setup
export extern "atuin init" []

# Generate a UUID
export extern "atuin uuid" []

# List contributors
export extern "atuin contributors" []

# Generate shell completions
export extern "atuin gen-completions" []

