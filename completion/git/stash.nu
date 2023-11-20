use wrapper git *

# Stash changes in a dirty working directory
export extern "git stash" [
  ...pathspec: path          # Paths to stash
  --patch(-p)                # Interactively add hunks of patch between the index and the work tree
  --staged(-S)               # Stash only the changes that are currently staged
  --keep-index(-k)           # All changes already added to the index are left intact
  --no-keep-index
  --quiet(-q)                # Suppress feedback
  --include-untracked(-u)    # Stash untracked files then clean up
  --all(-a)                  # Stash ignored and and untracked files then clean up
  --message(-m): string      # Stash message
  --pathspec-from-file: path # Read paths to stash from this file
  --pathspec-file-nul        # Paths in pathspec file are NUL separated
]

# Apply a single stashed state without removing it from the stash list
export extern "git stash apply" [
  --index     # Try to reinstate the index changes also
  --quiet(-q) # Suppress feedback
]

# Create a stash entry and return its objcet name
export extern "git stash create" [
  message?: string # Stash message
]

# Clear all stash entries
export extern "git stash clear" []

# Remove a single stash entry
export extern "git stash drop" [
  stash?: string # Stash commit to drop
  --index        # Try to reinstate the index changes also
  --quiet(-q)    # Suppress feedback
]

# List stash entries
export def "git stash list" () {
  stash_list
  | par-each { |row|
    $row |
    update date { |d| $d.date | into datetime }
  }
}

# Remove a single stashed state and apply it to the current working tree state
export extern "git stash pop" [
  stash?: string # Stash commit to pop
  --index        # Try to reinstate the index changes also
  --quiet(-q)    # Suppress feedback
]

# Save local modifications to a new stash entry
export extern "git stash push" [
  ...pathspec: path          # Paths to stash
  --patch(-p)                # Interactively add hunks of patch between the index and the work tree
  --staged(-S)               # Stash only the changes that are currently staged
  --keep-index(-k)           # All changes already added to the index are left intact
  --no-keep-index
  --quiet(-q)                # Suppress feedback
  --include-untracked(-u)    # Stash untracked files then clean up
  --all(-a)                  # Stash ignored and and untracked files then clean up
  --message(-m): string      # Stash message
  --pathspec-from-file: path # Read paths to stash from this file
  --pathspec-file-nul        # Paths in pathspec file are NUL separated
]

# Show changes record in the stash entry as a diff
export extern "git stash show" [
  stash?: string          # Stash commit
  --include-untracked(-u) # Show untracked files as part of the diff
  --only-untracked        # Show only the untracked files as part of the diff
]

# Store a stash from `git stash create`
export extern "git stash store" [
  commit: string        # Stash commit to store
  --message(-m): string # Stash message
  --quiet(-q)           # Suppress feedback
]
