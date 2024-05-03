use wrapper git *

def mirror [] {
  [
    { value: "fetch", description: "Mirror every ref from the remote repository locally" },
    { value: "push", description: "Push local refs to the remote repository" },
  ]
}

def remotes [] {
  git_remotes
  | select name url
  | rename value description
  | uniq
  | sort
}

# List existing remotes
export def "git remote" [
  --verbose(-v) # Show fetch and push URLs
] {
  let args = if $verbose {
    [ "--verbose" ]
  } else {
    []
  }

  let remotes = run-external "git" "remote" $args
  | lines

  if $verbose {
    $remotes
    | parse "{name}\t{url} ({operation})"
    | flatten
  } else {
    $remotes
  }
}

# Add a remote repository
export extern "git remote add" [
  name: string            # Remote name
  url: string             # Remote URL
  -t: string              # Track only this branch
  -f                      # Immediately fetch
  --tags                  # Import tags
  --no-tags               # Do not import tags
  --mirror: string@mirror # Create a mirror
]

# Retrieve URLs for a remote
#
# Expands insteadOf and pushInsteadOf
export extern "git remote get-url" [
  --push               # Push URLs queried
  --all                # List all URLs for the remote
  name: string@remotes # Name of remote
]

# Delete stale references
export extern "git remote prune" [
  --dry-run(-n)        # Report branches to prune without pruning them
  name: string@remotes # Name of remote
]

# Remove a remote
export extern "git remote remove" [
  name: string@remotes # Remote to remove
]

# Rename all remote-tracking branches and configuration settings
export extern "git remote rename" [
  --progress          # Show progress
  --no-progress       # Do not show progress
  old: string@remotes # Old name
  new: string         # New name
]

# Change the list of branches tracked by the named remote
export extern "git remote set-branches" [
  --add                # Add branches the the list of tracked branches
  name: string@remotes # Name of the remote
  ...branch: string    # Branches to track
]

# Set or delete the default branch
export extern "git remote set-head" [
  --auto(-a)           # Qurey the remote to determine its default branch
  --delete(-d)         # Delete the symbolic ref HEAD for this remote
  name: string@remotes # Name of the remote
  branch?: string      # Use this default branch
]

# Replace URLs for a remote
export extern "git remote set-url" [
  --push               # Set push URL instead of fetch URL
  name: string@remotes # Remote name
  newurl: string       # New URL
  oldurl?: string      # URL to replace (defaults to first URL)
]

# Add URLs for a remote
export extern "git remote set-url add" [
  --push               # Set push URL instead of fetch URL
  name: string@remotes # Remote name
  newurl: string       # Add a new URL
]

# Delete URLs for a remote
export extern "git remote set-url delete" [
  --push               # Set push URL instead of fetch URL
  name: string@remotes # Remote name
  url: string          # URL pattern
]

# Show inforation about a remote
export extern "git remote show" [
  -n                   # Do not query remote heads
  name: string@remotes # Name of the remote
]

# Fetch updates for remotes or remote groups
export extern "git remote update" [
  --prune(-p) # Run pruning against all the remotes that are updated
  name: string
]
