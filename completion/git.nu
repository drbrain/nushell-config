# Expanded from
# https://github.com/nushell/nushell/blob/main/crates/nu-utils/src/sample_config/default_config.nu
# which is covered by the MIT license

use wrapper git *

def local_branches [] {
  git_local_branches
  | select name
  | rename value
  | uniq
  | sort
}

def remote_branches [] {
  git_remote_branches
  | select name url
  | rename value description
  | uniq
  | sort
}

def branches_and_remotes [] {
  git_remotes
  | select name url
  | rename value description
  | append (
    git_local_branches | select name | rename value
  )
  | append (
    git_remote_branches | select name
    | rename value
  )
  | uniq
  | sort
}

def color [] {
  [
    { value: "always", description: "Always respect color in output" },
    { value: "never", description: "Never use color" },
    { value: "auto", description: "Use colors if the output is a terminal" }
  ]
}

def commits [] {
  git_commits --max-count 500
  | select ref subject
  | rename value description
}

def remotes [] {
  git_remotes
  | select name url
  | rename value description
  | uniq
  | sort
}

def commands [] {
  ^git help -a
  | lines
  | where $it =~ "^   "
  | str trim
  | each { |it| parse -r '(?<value>[\w-]+)\s+(?<description>.*)' }
  | flatten
  | sort
}

def conflict_style [] {
  [
    { value: "merge", description: "RCS style" },
    { value: "diff3", description: "RCS style with base hunk" },
    { value: "zdiff3", description: "diff3 omitting common lines in the conflict" },
  ]
}

def modified [] {
  git_status false
  | select name status
  | rename value description
}

# A revision control system
export extern main [
  command: string@commands
  args?: list
  --bare                 # Treat the repository as a bare repository
  --config-env: string   # Set configuration from an env var <name>=<envvar>
  --exec-path: string    # Path to core Git programs
  --git-dir: string      # Set path to the repository (".git" directory)
  --glob-pathspecs       # Add "glob" magic to all pathspecs
  --help                 # Show git help
  --html-path            # The path to Git's HTML documentation
  --icase-pathspecs      # Add "icase" magic to all pathspecs
  --info-path            # The path to Git's Info documentation
  --list-cmds: string    # List commands by group
  --literal-pathspecs    # Treat pathspecs literally (no globbing, etc.)
  --man-path             # The path to Git's manpath
  --namespace: string    # Set the git namespace
  --no-optional-locks    # Do not perform optional operations that require locks
  --no-pager(-P)         # Do not pipe output to a pager
  --no-replace-objects   # Do not use replacement refs to replace Git objects
  --noglob-pathspecs     # Add "literal" magic to all pathspecs
  --paginate(-p)         # Pipe all output to less (or $PAGER)
  --super-prefix: string # Set a prefix which gives a path from above a repository down to its root
  --version              # The git version
  --work-tree: string    # Set the path to the working tree
  -C: string             # Run as if the given path is CWD
  -c: string             # Set a configuration parameter <name>=<value>
]

# Add file contents to the index
export extern "git add" [
  ...pathspec: path@modified
  --all(-A)                  # Update the index where the working tree has a matching file or index entry
  --chmod: string            # Override the executable bit of added files
  --dry-run(-n)              # Don't add files, just show if the exist or will be ignored
  --edit(-e)                 # Open the diff against the index in an editor
  --force(-f)                # Allow adding ignored files
  --ignore-errors            # Ignore errors when indexing files
  --ignore-missing           # Only with --dry-run, check if files would be ignored
  --ignore-removal           # Add files unknown to the index and modified files, but no removed files
  --intent-to-add(-N)        # Record that the path will be added later
  --interactive(-i)          # Add modified contents in the working tree interactively to the index
  --no-all                   # See --ignore-removal
  --no-ignore-removal        # See as --all
  --no-warn-embedded-repo    # Do not warn about an embedded repository
  --patch(-p)                # Interactively add hunks of patch between the index and the work tree
  --pathspec-file-nul        # NUL separator for --path-spec-from-file
  --pathspec-from-file: glob # Read <pathspec> from this file
  --refresh                  # Refresh file stat() information in the index
  --renormalize              # Forcibly add tracked files to the index again
  --sparse                   # Allow updating index entries outside of the sparse-checkout cone
  --update(-u)               # Update the index just where it already has an entry matching <pathspec>
  --verbose(-v)              # Be verbose
  --help                     # Show help
]

# Show what revision and author last modified lines in a file
export extern "git blame" [
  file: path
  -b                         # Show blank SHA for boundary commits
  --root                     # Do not treat root commits as boundaries
  --show-stats               # Include additional statistics
  -L: string                 # Annotate a line range or function name
  -l                         # Show long revision
  -t                         # Show raw timestamp
  -S: path                   # Use revisions from this file
  --reverse: string          # Walk history forward instead of backward
  --first-parent             # Follow only the first parent commit upon seeing a merge commit
  --porcelain(-p)            # Use porcelain format
  --line-porcelain           # Porcelain format with commit information for each line
  --incremental              # Show result incrementally
  --encoding: string         # Encoding for author names and commit summaries
  --contents: path           # Pretend the working tree copy has these contents
  --date: string             # Format to output date utils
  --progress                 # Report progress status
  --no-progress              # Do not report progress status
  -M: number                 # Detect lines moved within a file
  -C: number                 # Detect lines moved across files
  --ignore-rev: string       # Ignore changes from this revision
  --ignore-revs-file: path   # Ignore revisions from this file
  --color-lines              # Color line annotations by commit they come from
  --color-by-age             # Color line annotations by age
  -c                         # Use same output mode as git-annotate
  --score-debug              # Include debugging information related to movement of lines between files
  --show-name(-f)            # Show the filename in the original commit
  --show-number(-n)          # Show the line number in the original commit
  -s                         # Suppress author and timestamp
  --show-email(-e)           # Show author email instead of name
  -w                         # Ignore whitespace
  --abbrev: number           # Abbreviate commit SHA to this many characters
  --help(-h)                 # Show help
]

# List, create, or delete branches
export extern "git branch" [
  branch?: string@branches_and_remotes
  --abbrev: string
  --all(-a)
  --color: string@color
  --column: string
  --contains: string
  --copy(-c)
  --create-reflog
  --delete(-d)
  --edit-description
  --force(-f)
  --format: string
  --ignore-case(-i)
  --help
  --list(-l)
  --merged: string
  --move(-m)
  --no-abbrev
  --no-color
  --no-column
  --no-contains: string
  --no-merged: string
  --no-track
  --points-at: string
  --quiet(-q)                  # Suppress progress reporting
  --remotes(-r)
  --set-upstream
  --set-upstream-to(-u): string@remotes
  --show-current
  --sort: string
  --track(-t): string
  --unset-upstream
  --unset-upstream: string
  --verbose(-v)
  -C
  -D
  -M
  --help                     # Show help
]

# Restore working tree files
export extern "git checkout" [
  ...pathspec: path@modified   # Limit paths to checkout
  -b: string                   # Create and checkout a new branch
  -B: string                   # Create/reset and checkout a branch
  -l                           # Create reflog for new branch
  --guess                      # Second guess 'git checkout <no-such-branch>' (default)
  --overlay                    # Use overlay mode (default)
  --quiet(-q)                  # Suppress progress reporting
  --recurse-submodules: string # Control recursive updating of submodules
  --progress                   # Force progress reporting
  --merge(-m)                  # Perform a 3-way merge with the new branch
  --conflict: string           # Conflict style (merge or diff3)
  --detach(-d)                 # Detach HEAD at named commit
  --track(-t)                  # Set upstream info for new branch
  --force(-f)                  # Force checkout (throw away local modifications)
  --orphan: string             # New unparented branch
  --overwrite-ignore           # Update ignored files (default)
  --ignore-other-worktrees     # Do not check if another worktree is holding the given ref
  --ours(-2)                   # Checkout our version for unmerged files
  --theirs(-3)                 # Checkout their version for unmerged files
  --patch(-p)                  # Interactively add hunks of patch between the index and the work tree
  --ignore-skip-worktree-bits  # Do not limit pathspecs to sparse entries only
  --pathspec-from-file: string # Read pathspec from file
  --help                       # Show help
]

# Apply changes introduced by existing commits
export extern "git cherry-pick" [
  ...commits: string@commits    # Commit to cherry-pick
  --edit(-e)                    # Edit the message prior to committing
  --cleanup: string             # Set message cleanup mode
  -x                            # Append "(cherry picked from commit ...)" to message
  -r                            # Don't do -x (deprecated)
  --mainline(-m): number        # Set mainline when cherry-picking a merge commit
  --no-commit(-n)               # Apply changes without creating a commit
  --signoff(-s)                 # Add signed-off-by
  --gpg-sign(-S): string        # GPG-sign commits
  --no-gpg-sign                 # Do not GPG-sign commits
  --ff                          # Attempt fast-forward
  --allow-empty                 # Allow an empty commit
  --allow-empty-message         # Allow an empty message
  --keep-redundant-commits      # Allow a redundant commit
  --strategy(-s): string        # Choose the merge strategy
  --strategy-option(-X): string # Set a merge strategy option
  --rerere-autoupdate           # Allow rerere to update the index
  --no-rerere-autoupdate        # Disallow rerere updates
  --continue                    # Proceed after resolving conflicts
  --skip                        # Skip commit and continue operation
  --quit                        # Forget the in-progress operation
  --abort                       # Cancel the operation
  --help                        # Show help
]

# Clone a repository into a new directory
export extern "git clone" [
  --local(-l)                  # Copy HEAD, objects, and refs directories from a local repo
  --no-hardlinks               # Don't use hard links to .git/objects when cloning a local repo
  --shared(-s)                 # Share objects with a local repo (instead of hard links)
  --reference: string          # Obtain objects from a local reference repository
  --dissociate                 # Borrow objects from reference repos only to reduce network transfer
  --quiet(-q)                  # Operate quietly
  --verbose(-v)                # Run verbosely
  --progress                   # Force progress even when stderr is not a TTY
  --server-option: string      # Send an option string to the server
  --no-checkout(-n)            # Do not check out HEAD after cloning
  --reject-shallow             # Fail if the source repo is shallow
  --no-reject-shallow          # Allow a shallow source repo
  --bare                       # Make a bare git repository
  --sparse                     # Make a sparse checkout
  --filter: string             # Use the partial clone feature with this filter
  --also-filter-submodules     # Apply the clone filter to submodules
  --mirror                     # Mirror the source repository
  --origin(-o): string         # Set the name of the upstream repository
  --branch(-b): string         # Set HEAD to this branch
  --upload-pack(-u): string    # Run a different upload-pack for SSH repos
  --template: string           # Specify the template directory
  --config(-c): string         # Set a configuration variable in the cloned repo
  --depth: number              # Truncate history depth
  --shallow-since: string      # Truncate history depth to a date
  --shallow-exclude: string    # Truncate history reachable from a revision
  --single-branch              # Clone history leading to the tip of a single branch
  --no-single-branch
  --no-tags                    # Don't clone tags
  --recurse-submodules: string # Initialize and clone submodules
  --shallow-submodules         # Clone submodules with a depth of 1
  --no-shallow-submodules
  --remote-submodules          # Use the submodule remote tracking branch to update the submodule
  --no-remote-submodules       # Use the super-project's commit when cloning submodules
  --jobs(-j): number           # How many submodules to clone at once
  --help                       # Show help
  repository: string           # Repository to clone
  directory?: string           # Directory to clone into
]

# Record changes to the repository
export extern "git commit" [
  ...pathspec: path@modified
  -a
  --interactive
  --patch(-p)                # Interactively add hunks of patch between the index and the work tree
  -s
  -v
  -u: string
  --amend
  --dry-run
  --squash: string
  -c: string
  -C: string
  --fixup: string
  -F: glob
  -m: string
  --reset-author
  --allow-empty                # Allow an empty commit
  --allow-empty-message        # Allow an empty message
  --no-verify-e
  --author: string
  --date: string
  --cleanup: string
  --no-status
  --status
  -i
  -o
  --pathspec-from-file: glob
  --pathspec-file-nul
  --trailer: string
  -S: string
  --help                       # Show help
]

def config_type [] {
  [
    { value: "bool", description: "true or false" },
    { value: "bool-or-int", description: "bool or int" },
    { value: "color", description: "Expressible as an ANSI color" },
    { value: "expiry-date", description: "Fixed or relative date" },
    { value: "int", description: "Decimal number with an optional k, m, g suffix" },
    { value: "path", description: "Path to a file" },
  ]
}

# Get and set repository or global options
export extern "git config" [
  name: string
  value?: any
  value_pattern?: any
  --replace-all              # Replace all matching lines
  --add                      # Add a new line without altering exitsing values
  --get                      # Get the value for a key
  --get-all                  # Get all values for a multi-value key
  --get-regexp               # Get values matching a regexp
  --get-urlmatch: string     # Get a value by URL match
  --global                   # Use user .gitconfig
  --system                   # Use system .gitconfig
  --local                    # Use repository .gitconfig
  --worktree                 # Use worktree .gitconfig
  --file(-f): string         # Use named git config
  --blob: string             # Read from a blob
  --remove-section           # Remove a remove a section
  --rename-section           # Rename a section
  --unset                    # Remove a line
  --unset-all                # Remove all lines
  --list(-l)                 # List set variables and values
  --fixed-value              # Match exactly
  --type: string@config_type # Validate value type
  --no-type                  # Unset type validation
  --null(-z)                 # End output values with a NUL
  --name-only                # Output only names
  --show-origin              # Show config value origin file
  --show-scope               # Show config value origin scope
  --get-colorbool: string    # Output bool if color should be used
  --get-color: string        # Retrive a color with a default
  --edit(-e)                 # Modifiy configuration in an editor
  --includes                 # Respect includes when looking up values
  --no-includes              # Ignore includes when looking up values
  --default                  # Default value when using --get
  --help                     # Show help
]

# Show changes between commits, commit and tree, etc.
export extern "git diff" [
  branch?: string@local_branches
  ...pathspec: path@modified          # Files to diff
  --cached
  --merge-base
  --staged
  --patch(-p)                # Interactively add hunks of patch between the index and the work tree
  -u
  --no-patch(-s)
  --unified(-U): number
  --ignore-all-space(-w)
  --ignore-blank-lines
  --ignore-cr-at-eol         # Ignore CR at EOL
  --ignore-space-at-eol      # Ignore changes in whitespace at EOL
  --ignore-space-change(-b)
  --quiet
  --help                     # Show help
]

# Download objects and refs from another repository
export extern "git fetch" [
  repository: string                   # The remote repository or group of repositories
  ...refspec: string                   # Refs to fetch and local refs to update
  --all                                # Fetch all remotes
  --append(-a)                         # Append ref and object names of fetched refs to the existing FETCH_HEAD
  --atomic                             # Use an atomic transaction to update local refs
  --depth: number                      # Limit fetching to the specified number of commits from the remote tip
  --deepen: number                     # Limit fetching to the specified number of commits from the current shallow boundary
  --shallow-since: string              # Update the history of a shallow repository to include commits after this date
  --shallow-exclude: string            # Update the history of a shallow repository to exclude commits reachable from this revision
  --unshallow                          # Convert a shallow repository into a complete repository
  --update-shallow                     # Accept refs that require updating .git/shallow
  --negotiation-tip: string            # Report commits reachable from the given tips
  --negotiate-only                     # Only print ancestors of negotaited tips
  --dry-run                            # Do not make changes
  --porcelain                          # Porcelain output
  --write-fetch-head                   # Write the list of remote refs fetched in FETCH_HEAD
  --no-write-fetch-head                # Do not write the remote refs fetched
  --force(-f)                          # Force update local branches
  --keep(-k)                           # Keep the downloaded pack
  --multiple                           # Allow serveral repository and group arguments
  --auto-maintenance                   # Run automatic repository maintenance if needed
  --no-auto-maintenance                # Do not run automatic maintenance
  --auto-gc                            # Run automatic repository maintenance if needed
  --no-auto-gc                         # Do not run automatic maintenance
  --write-commit-graph                 # Write a commit graph after fetching
  --no-write-commit-graph              # Do not write a commit graph after fetching
  --prefetech                          # Modify the configured refspec to place all refs into refs/prefetch
  --prune(-p)                          # Remove any remote-tracking references that no longer exits on the remote before fetching
  --prune-tags(-P)                     # Remove any local tags that no longer exist on the remote before fetching
  --no-tags(-n)                        # Do not automatically fetch tags
  --refetch                            # Fetch all objects like a fresh clone would
  --refmap: string                     # Use this refspec to map refs to remote-tracking branches
  --tags(-t)                           # Fetch tags from the remote
  --recurse-submodules: string         # Set submodule recursion fetching
  --jobs(-j): number                   # Number of parallel children to use
  --no-recurse-submodules              # Disable recursive fetching of submodules
  --set-upstream                       # Set an upstream tracking reference
  --submodule-prefix: path             # Prepend this path to printed submodule paths
  --recurse-submodules-default: string # Set a temporary non-negative default value for--recurse-submodules
  --update-head-ok(-u)                 # Update the head that corresponds to the current branch
  --upload-pack: string                # Specify a non-default path for the command run on the remote
  --quiet(-q)                          # Do not report progress
  --verbose(-v)                        # Be verbose
  --progress                           # Report progress on stderr
  --server-option(-o): string          # Transmit the option to the server
  --show-forced-updates                # Show if a branch is force-updated
  --no-show-forced-updates             # Disable showing forced updates
  --ipv4(-4)                           # Use IPv4 only
  --ipv6(-6)                           # Use IPv6 only
]

# Verify the connectivity and validity of objects in the database
export extern "git fsck" [
  ...object: string   # An object to treat as the head of an unreachability trace
  --unreachable       # Show objects that exist but are unreachable from the reference nodes
  --dangling          # Print objects that exist but are never directly used
  --no-dangling       # Omit dangling objects
  --root              # Report root nodes
  --tags              # Report tags
  --cached            # Consider any object recording in the index as a head node for an unreachability trace
  --no-reflogs        # Do not consider commits that are referenced only by a reflog entry to be reachable
  --full              # Check objects found in alternate object pools and packed git archives
  --connectivity-only # Check only the connectivity of reachable objects
  --strict            # Enable more strict checking
  --verbose           # Be verbose
  --lost-found        # Write dangling objects into the lost-found directory
  --name-objects      # Display how a named object is reachable
  --progress          # Report progress status
  --no-progress       # Do not report progress status
]

# Clean and optimize the local repository
export extern "git gc" [
  --aggressive        # Optimize more agressively and take more time
  --auto              # Check if housekeeping is required and exit if none is required
  --cruft             # Pack unreachable objects into a cruft pack instead of as loose objects
  --force             # Force gc run even if another gc may be running
  --keep-largest-pack # Consolidate most packs
  --no-cruft          # Leave unreachable objects loose
  --no-prune          # Do not prune loose objects
  --prune: string     # Prune loose objects older than this date
  --quiet             # Suppress output
]

# Show a simplified view of recent history
export def "git hist" [
  --max-count: int = 500 # Number of commits to show
] {
  git_commits --max-count $max_count
  | move author --after subject
  | move date --after author
  | explore
}

# Create or reinitialize a git repository
export extern "git init" [
  directory: path              # Directory to create a git repository in
  --quiet(-q)                  # Only print error and warning messages
  --bare                       # Create a bare repository
  --object-format: string      # Specify the object format
  --template: path             # Repository template directory
  --separate-git-dir: path     # Set the repository .git dir to this path
  --initial-branch(-b): string # The name of the initial branch
  --shared: string             # Share the git directory
  --help                       # Show help
]

def decorate () {
  [
    { value: "auto", description: "Short ref names for TTY output" },
    { value: "full", description: "Include ref prefixes" },
    { value: "no", description: "Don't decorate" },
    { value: "short", description: "Omit refs/* prefixes" },
  ]
}

# Show commit logs
export extern "git log" [
  revision_range?: string      # Show commits in this revision range
  ...pathspec: path            # Show commits for these files
  --follow                     # Follow file renames
  --decorate: string@decorate  # Print ref names of any commits that are shown
  --no-decorate                # Do not print ref names
  --clear-decorations          # Clear previous decoration options
  --source                     # Print the ref name from the command line by which each commit was reached
  --mailmap                    # Use mailmap file to map author and commiter names
  --no-mailmap                 # Disable use of mailmap
  --use-mailmap                # Use mailmap file to map author and commiter names
  --no-use-mailmap             # Disable use of mailmap
  --full-diff                  # Show a full diff for commits that touch listed paths
  --log-size                   # Show the length of each commit's message in bytes
  -L: string                   # Trace the evolution of a line range
]

# Join two or more branches together
export extern "git merge" [
  commit?: string
  --commit                      # Merge and commit
  --no-commit                   # Merge but do not commit
  --edit(-e)                    # Launch EDITOR for merge message
  --no-edit                     # Accept auto-generated merge message
  --cleanup: string             # Set merge message cleanup
  --ff                          # Attempt fast-forward
  --no-ff                       # Always create a merge commit
  --ff-only                     # Fast-forward or fail to merge
  --gpg-sign(-S): string        # GPG-sign the merge commit
  --no-gpg-sign                 # Do not GPG-sign the merge commit
  --log: number                 # Populate merge message with N commit descriptions
  --no-log                      # Do not list commit descriptions
  --signoff                     # Add signed-off-by
  --no-signoff                  # Omit signed-off-by
  --stat                        # Show diffstat
  --no-stat(-n)                 # Omit diffstat
  --squash                      # Squash merge
  --no-squash                   # Do not squash merge
  --verify                      # Run pre-merge and commit-msg hooks
  --no-verify                   # Skip pre-merge and commit-msg hooks
  --strategy(-s): string        # Choose the merge strategy
  --strategy-option(-X): string # Set a merge strategy option
  --verify-signatures           # Verify commit signatures
  --no-verify-signatures        # Skip signature verification
  --quiet(-q)                   # Operate quietly
  --verbose(-v)                 # Be verbose
  --progress                    # Turn on progress
  --no-progress                 # Disable progress
  --autostash                   # Stash and unstash around merge
  --no-autostash                # Disable autostash
  --allow-unrelated-histories   # Merge commits without a common ancestor
  -m: string                    # Merge message
  --into-name: string@local_branches # Prepare merge message as if merging into this branch
  --file(-F): path              # Read commit message from this file
  --rerere-autoupdate           # Allow rerere to update the index
  --no-rerere-autoupdate        # Disallow rerere updates
  --overwrite-ignore            # Silently overwrite ignored files
  --no-overwrite-ignore         # Abort without overwriting ignored files
  --abort                       # Abort conflict resolution
  --quit                        # Forget about the merge in progress
  --continue                    # Proceed after resolving conflicts
  --help                        # Show help
]

def rebase [] {
  [
    { value: "false", description: "Do not rebase" },
    { value: "interactive", description: "Interactive rebase" },
    { value: "merges", description: "Include local merge commits in the rebase" },
    { value: "true", description: "Rebase atop the upstream branch after fetching" },
  ]
}

def recurse_submodules [] {
  [
    { value: "yes", description: "Recurse into all populated submodules" },
    { value: "on-demand", description: "Recurse into changed submodules" },
    { value: "no", description: "Do not recurse into submodules" },
  ]
}

# Fetch from and integrate with another repository or a local branch
export extern "git pull" [
  repository?: string@branches_and_remotes         # The remote source repository
  ...respec: string@remote_branches               # Which refs to fetch and update locally
  --no-recurse-submodules                         # Do not update submodules when restoring
  --quiet(-q)                                     # Operate quietly
  --recurse-submodules: string@recurse_submodules # Update submodules when restoring
  --verbose(-v)                                   # Be verbose
  --commit                                        # Merge and commit
  --no-commit                                     # Merge but do not commit
  --edit(-e)                                      # Launch EDITOR for merge message
  --no-edit                                       # Accept auto-generated merge message
  --cleanup: string                               # Set merge message cleanup
  --ff                                            # Attempt fast-forward
  --no-ff                                         # Always create a merge commit
  --ff-only                                       # Fast-forward or fail to merge
  --gpg-sign(-S): string                          # GPG-sign the merge commit
  --no-gpg-sign                                   # Do not GPG-sign the merge commit
  --log: number                                   # Populate merge message with N commit descriptions
  --no-log                                        # Do not list commit descriptions
  --signoff                                       # Add signed-off-by
  --no-signoff                                    # Omit signed-off-by
  --stat                                          # Show diffstat
  --no-stat(-n)                                   # Omit diffstat
  --squash                                        # Squash merge
  --no-squash                                     # Do not squash merge
  --verify                                        # Run pre-merge and commit-msg hooks
  --no-verify                                     # Skip pre-merge and commit-msg hooks
  --strategy(-s): string                          # Choose the merge strategy
  --strategy-option(-X): string                   # Set a merge strategy option
  --verify-signatures                             # Verify commit signatures
  --no-verify-signatures                          # Skip signature verification
  --summary                                       # Output a condensed summary of extended header information
  --autostash                                     # Stash and unstash around merge
  --no-autostash                                  # Disable autostash
  --allow-unrelated-histories                     # Merge commits without a common ancestor
  --rebase(-r): string@rebase                     # Control rebasing of the current branch
  --no-rebase                                     # Merge the upstream branch into the current branch
  --all                                           # Fetch all remotes
  --append(-a)                                    # Append ref and object names of fetched refs to the existing FETCH_HEAD
  --atomic                                        # Use an atomic transaction to update local refs
  --depth: number                                 # Limit fetching to the specified number of commits from the remote tip
  --deepen: number                                # Limit fetching to the specified number of commits from the current shallow boundary
  --shallow-since: string                         # Update the history of a shallow repository to include commits after this date
  --shallow-exclude: string                       # Update the history of a shallow repository to exclude commits reachable from this revision
  --unshallow                                     # Convert a shallow repository into a complete repository
  --negotiation-tip: string                       # Report commits reachable from the given tips
  --negotiate-only                                # Only print ancestors of negotaited tips
  --dry-run                                       # Do not make changes
  --porcelain                                     # Porcelain output
  --force(-f)                                     # Force update local branches
  --keep(-k)                                      # Keep the downloaded pack
  --prefetech                                     # Modify the configured refspec to place all refs into refs/prefetch
  --prune(-p)                                     # Remove any remote-tracking references that no longer exits on the remote before fetching
  --no-tags(-n)                                   # Do not automatically fetch tags
  --refmap: string                                # Use this refspec to map refs to remote-tracking branches
  --tags(-t)                                      # Fetch tags from the remote
  --jobs(-j): number                              # Number of parallel children to use
  --set-upstream                                  # Set an upstream tracking reference
  --upload-pack: string                           # Specify a non-default path for the command run on the remote
  --progress                                      # Report progress on stderr
  --server-option(-o): string                     # Transmit the option to the server
  --show-forced-updates                           # Show if a branch is force-updated
  --no-show-forced-updates                        # Disable showing forced updates
  --ipv4(-4)                                      # Use IPv4 only
  --ipv6(-6)                                      # Use IPv6 only
]

# Move or rename files, directories, or symlinks
export extern "git mv" [
  ...source: glob
  destination: path
  --force(-f)   # Force renaming or moving of a file even if the target exists
  -k            # Skip move or rename actions which would lead to an error condition
  --dry-run(-n) # Do nothing; only show what would happen
  --verbose(-v) # Report the names of files as they are moved
  --help        # Show help
]

# Update remote refs along with associated objects
export extern "git push" [
  remote?: string@remotes               # The remote to push to
  refspec?: string@local_branches       # The branch to push
  --verbose(-v)                         # be more verbose
  --quiet(-q)                           # be more quiet
  --repo: string                        # repository
  --all                                 # push all refs
  --mirror                              # mirror all refs
  --delete(-d)                          # delete refs
  --tags                                # push tags (can't be used with --all or --mirror)
  --dry-run(-n)                         # dry run
  --porcelain                           # machine-readable output
  --force(-f)                           # force updates
  --force-with-lease: string            # require old value of ref to be at this value
  --recurse-submodules: string          # control recursive pushing of submodules
  --thin                                # use thin pack
  --receive-pack: string                # receive pack program
  --exec: string                        # receive pack program
  --set-upstream(-u)                    # set upstream for git pull/status
  --progress                            # force progress reporting
  --prune                               # prune locally removed refs
  --no-verify                           # bypass pre-push hook
  --follow-tags                         # push missing but relevant tags
  --signed: string                      # GPG sign the push
  --atomic                              # request atomic transaction on remote side
  --push-option(-o): string             # option to transmit
  --ipv4(-4)                            # use IPv4 addresses only
  --ipv6(-6)                            # use IPv6 addresses only
  --help                                # Show help
]

def empty [] {
  [
    { value: drop, description: "Empty commits are dropped" },
    { value: keep, description: "Empty commits are kept" },
    { value: ask, description: "Stop and ask when empty" },
  ]
}

# Reapply commits on top of another base tip
export extern "git rebase" [
  upstream?: string@branches_and_remotes # Upstream branch to compare against
  branch?: string@local_branches         # working branch (default: HEAD)
  --continue                             # Restart rebasing after resolving a conflict
  --skip                                 # Restart rebasing after skipping the current patch
  --abort                                # Abort rebasing and reset HEAD to the original branch
  --quit                                 # Abort rebasing but HEAD is not reset to the original branch
  --edit-todo                            # Edit the todo list during interactive rebase
  --show-current-patch                   # Show the current patch when the rebase is stopped
  --onto: string@local_branches          # Starting point for creating new commits
  --keep-base                            # Set the starting point for creating new commits to the merge base of (upstream) and (branch)
  --apply                                # Use applying strategies to rebase
  --empty: string@empty                  # How to handle commits that become empty after rebasing
  --keep-empty                           # Keep empty commits when rebasing starts
  --no-keep-empty                        # Do not keep empty commits when rebasing starts
  --reapply-cherry-picks                 # Reapply all clean cherry-picks of any upstream commit
  --no-reapply-cherry-picks              # Do not reapply clean cherry-picks
  --merge(-m)                            # Use merging strategies to rebase
  --strategy(-s): string                 # Use the given merge strategy instead of the default of ort
  --strategy-option(-X): string          # Set a merge strategy-specific option
  --rerere-autoupdate                    # Allow rerere to update the index
  --no-rerere-autoupdate                 # Do not allow rerere to update the index
  --gpg-sign(-S): string                 # GPG-sign commits
  --no-gpg-sign                          # Do not GPG-sign commits
  --quiet(-q)                            # Suppress output
  --verbose(-v)                          # Be verbose
  --stat                                 # Show diffstat
  --verify                               # Run pre-merge and commit-msg hooks
  --no-verify                            # Skip pre-merge and commit-msg hooks
  -C: int                                # Show this many context lines
  --force-rebase(-f)                     # Replay all commits instead of fast-forwarding over unchanged ones
  --no-ff                                # Replay all commits instead of fast-forwarding over unchanged ones
  --fork-point                           # Use reflog to find a better common ancestor between (upstream) and (branch)
  --no-fork-point                        # Do not try to find a better common ancestor
  --ignore-whitespace                    # Ignore whitespace differences when trying to reconcile differences
  --whitespace: string                   # Detect a new or modified line with whitespace errors (see git-apply)
  --committer-date-is-author-date        # Use the auther date of the commit being rebased as the committer date
  --ignore-date                          # Use the current time as the author date for rebased commits
  --reset-author-date                    # Use the current time as the author date for rebased commits
  --signoff)                             # Add signed-off-by
  --interactive(-i)                      # Make an editable list of commits to rebase
  --rebase-merges(-r): string            # Try to preserve branching structure in rebased commits
  --no-rebase-merges                     # Place rebased commits in a single linear branch
  --exec(-x): string                      # Append `exec (cmd)` after each line creating a commit
  --root                                 # Rebase all commits reachable from (branch)
  --autosquash                           # Automatically modifiy the interactive todo list for squashable changes
  --no-autosquash                        # Do not autosquash
  --autostash                            # Create a temporary stash entry before rebasing and apply it at the end
  --no-autostash                         # Do not autostash
  --reschedule-faild-exec                # Reschedule exec commands that failed
  --no-reschedule-faild-exec             # Do not reschedule exec commands that failed
  --update-refs                          # Automatically force-update any branches that point to rebased commits
  --no-update-refs                       # Do not update branches that point to rebased commits
  --help                                 # Show help
]

def remote_commands [] {
  [ "add", "rename", "remove", "set-head", "set-branches", "get-url", "set-url", "prune" ]
}

# Manage set of tracked repositories
export extern "git remote" [
  command?: string@remote_commands # Command to run
  --verbose(-v)                    # Show URL after name
  --help                           # Show help
]

def mirror [] {
  [ "fetch", "push" ]
}

# Add a remote repository
export extern "git remote add" [
  name: string
  url: string
  -t: string@remotes      # Track only this branch
  -f                      # Immediately fetch
  --tags                  # Import tags
  --no-tags               # Do not import tags
  --mirror: string@mirror # Create a mirror
]

# Restore working tree files
export extern "git restore" [
  ...pathspec: path@modified  # Paths to restore
  --source(-s): string        # Restore the working tree with content from this tree
  --patch(-p)                 # Interactively add hunks of patch between the index and the work tree
  --worktree(-W)              # Restore from worktree
  --staged(-S)                # Restore from index
  --quiet(-q)                 # Supress feedback
  --progress                  # Show progress status
  --no-progress               # Don't show progress status
  --ours                      # Restore file from our index
  --theirs                    # Restore file from their index
  --merge(-m)                 # Recreate the conflicted merge in unmrged paths
  --conflict: string          # Present conflicts with this style
  --ignore-unmerged           # Do not abort if there are unmerged entries
  --ignore-skip-worktree-bits # Do not limit pathspecs to sparse entries only
  --recurse-submodules        # Update submodules when restoring
  --no-recurse-submodules     # Do not update submodules when restoring
  --overlay                   # Do not remove files when restoring
  --no-overlay                # Remove index-deleted tracked files when restoring
  --pathspec-file-nul         # NUL separator for --pathspec-from-file
  --pathspec-from-file: glob  # Read <pathspec> from this file
  --help                      # Show help
]

# Pick out and massage parameters
export extern "git rev-parse" [
  --parseopt              # Use git rev-parse option in parsing mode
  --keep-dashdash         # Echo first -- in --parseopt mode
  --stop-at-non-option    # Stop at the first non-option in --parseopt mode
  --stuck-long            # Output long options in --parseopt mode
  --sq-quote              # Use git rev-parse in shell quoting mode
  --revs-only             # Omit flags and parameters not meant for git rev-list
  --no-revs               # Omit flags and parameters meant for git rev-list
  --flags                 # Omit non-flag parameters
  --no-flags              # Omit flag parameters
  --default: string       # Use the argument as a default parameter
  --prefix: string        # Behave as if invoked from this subdirectory
  --verify                # Verify the parameter matches an object
  --quiet(-q)             # Do not output an error if verification fails
  --sq                    # Single line output for shell consumption
  --short                 # --verify with a shortened object name
  --short: number         # --verify with a shortened object name
  --not                   # Prepend object names with ^
  --abbrev-ref: string    # A non-ambiguous short name of the object's name
  --symbolic              # Output names as close to the original input as possible
  --symbolic-full-name    # --symbolic, but show full names for non-refs
  --all                   # Show all refs found
  --branches: string      # Show all branches matching this pattern
  --tags: string          # Show all tags matching this pattern
  --remotes: string       # Show all remotes matching this pattern
  --glob-pattern          # Show all refs matching this glob
  --exclude: string       # Exclude refs matching this glob
  --disambiguate: string  # Show all objects starting with this prefix
  --local-env-vars        # List GIT_ environment variables local to the repository
  --path-format: string   # Set the path format
  --git-dir               # Show $GIT_DIR or the path to the .git directory
  --git-common-dir        # Show $GIT_COMMON_DIR if defined, else $GIT_DIR
  --resolve-git-dir: path # Check if path is a valid repository or a gitfile that points at a repository
  --git-path: path        # Resolve $GIT_DIR/path accounting fro relocation variables
  --show-toplevel         # Show the path of the top-level directory of the working tree
  --show-superproject-working-tree # Show the root of the superproject's working tree
  --shared-path-index     # Show the path to the shared index file in split index mode
  --absolute-git-dir      # --git-dir with an absolute path
  --is-inside-git-dir     # Print true if the working directory is inside the repository directory
  --is-inside-work-tree   # Print true if the working directory is inside the repository
  --is-bare-repository    # Print true if the repository is bare
  --is-shallow-repository # Print true if the repository is shallow
  --show-cdup             # Show the path to the top-level directory from the current directory
  --show-prefix           # Show the path of the current directory relative to the top-level directory
  --show-object-format: string # Show the object format for storage inside the .git directory
  --since: string         # Show objects after this date
  --until: string         # Show objects before this date
  args: string
  --help                  # Show help
]

# Revert some existing commits
export extern "git revert" [
  commit?: string
  --edit(-e)                    # Edit the revert commit message
  --mainline(-m): number        # Merge commit mainline commit number
  --no-edit                     # Do not edit the revert commit message
  --cleanup: string             # How to clean the commit message
  --no-commit(-n)               # Revert, but do not commit
  --gpg-sign(-S): string        # GPG-sign commits
  --no-gpg-sign                 # Do not GPG-sign commits
  --signoff(-s)                 # Added Signed-off-by trailer to commit message
  --strategy: string            # Use this merge strategy
  --strategy-option(-X): string # Set a merge strategy-specific option
  --rerere-autoupdate           # Allow rerere to update the index
  --no-rerere-autoupdate        # Do not allow rerere to update the index
  --continue                    # Continue the revert operation
  --skip                        # Skip commit and continue operation
  --quit                        # Forget the in-progress operation
  --abort                       # Cancel the operation
  --help                        # Show help
]

def deletable [] {
  git_files
  | get path
  | uniq
}

# Remove files from the working tree and index
export extern "git rm" [
  ...pathspec: path@deletable   # Files to remove
  --force(-f)                   # Override the up-to-date check
  --dry-run(-n)                 # Don't remove files, just show if they would  be
  -r                            # Allow recursive removal of directories
  --cached                      # Unstage and removes paths only from the index
  --ignore-unmatch              # Exit with zero even if no files were matched
  --sparse                      # Allow updating index entries outside of the sparse-checkout
  --quiet(-q)                   # Suppress output
  --pathspec-from-file: path    # Read paths from file
  --pathspec-file-nul           # NUL separator for --pathspec-from-file
  --help                        # Show help
]

def diff_algorithm [] {
  [
    "default",
    "histogram",
    "minimal",
    "myers",
    "patience",
  ]
}

# Show various types of objects
export extern "git show" [
  commit?: string
  ...paths: path
  --pretty: string                    # Pretty-print the contents of commit logs
  --format: string                    # Pretty-print the contents of commit logs
  --abbrev-commit                     # Show a prefix that names the object uniquely
  --no-abbrev-commit                  # Show the full commit name
  --oneline                           # Shortcut for --pretty=oneline --abbrev-commit
  --enocding: string                  # Transcode log messages
  --expand-tabs                       # Expand tabs to 8 spaces
  --expand-tabs: number               # Expand tabs to this many spaces
  --no-expand-tabs                    # Disable tab expansions
  --notes: string                     # Show the notes that annotate the commit
  --no-notes                          # Do not show nodes
  --show-signature                    # Check signed commit validity
  --patch(-p)                         # Generate a patch
  -u                                  # Generate a patch
  --no-patch(-s)                      # Suppress diff output
  --diff-merges: string               # Specify diff format for merge commits
  --no-diff-merges                    # Disable output of diffs for merge commits
  --combined-all-paths                # List file name from all parents of combined diffs
  --unified(-U): number               # Generate diffs with <n> lines of context
  --output: string                    # Output to a file
  --output-indicator-new: string      # Specify patch added line character
  --output-indicator-old: string      # Specify patch removed context line character
  --output-indicator-context: string  # Specify patch context line character
  --raw                               # Show a summary of changes using raw diff format
  --patch-with-raw                    # Shortcut for -p --raw
  -t                                  # Show the tree objects in the diff output
  --indent-heuristic                  # Shift diff hunk boundaries to make patches easier to read
  --no-indent-heuristic               # Disable the indent heuristic
  --minimal                           # Produce the smallest possible diff
  --patience                          # Use the "patience diff" algorithm
  --historgam                         # Use the "historgram diff" algorithm
  --anchored: string                  # Use the "anchored diff" algorithm
  --diff-algorithm: string@diff_algorithm # Choose a diff algorithm
  --stat: string                      # Generate a diffstat
  --compact-summary                   # Output a summary of extended header information
  --numstat                           # Like --stat, but more machine-friendly
  --shortstat                         # Only the last line of --stat
  --dirstat(-X): string               # Output the distribution of relative change per sub-directory
  --cumulative                        # Shortcut for --dirstat=cumulative
  --dirstat-by-file: string           # Shortcut for --dirstt=files,…
  --summary                           # Output a condensed summary of extended header information
  --patch-with-stat                   # Shortcut for -p --stat
  -z                                  # Separate commits with NULs
  --name-only                         # Show only names of changed files
  --name-status                       # Show names and status of changed files
  --submodule: string                 # Specify how differences in submodules are shown
  --color: string@color               # Show colored diff
  --no-color                          # Turn off colored diff
  --color-moved: string               # Color moved lines differently
  --no-color-moved                    # Turn off move detection
  --color-moved-ws: string            # Configure how whitespace is ignored with move detection
  --no-color-moved-ws                 # Do not ignore whitespace when performing move detection
  --word-diff: string                 # Show a word diff
  --word-diff-regex: string           # Use <regex> to decide what a word is
  --color-words: string               # Shortcut for --word-diff=color --word-diff-regex=<regex>
  --no-renames                        # Turn off rename detection
  --rename-empty                      # Use empty blobs as rename source
  --no-rename-empty                   # Do not use empty blobs as rename source
  --check                             # Warn if changes introduce conflict markers or whitespace errors
  --ws-error-highlight: string        # Highlight whitespace errors
  --full-index                        # Show full pre- and post-image blob object names
  --binary                            # Output a binary diff for git-apply
  --abbrev: number                    # Show the shortest prefix of at least <n> hexdigits
  --break-rewrites(-B): string        # Break complete rewrite changes into delete/create pairs
  --find-renames(-M): number          # Detect and report renames for each commit
  --find-copies(-C): number           # Find copies as well as renames
  --find-copies-harder                # Inspect unmodified files as source candidates
  --irreversible-delete(-D)           # Omit delete preimages
  -l: number                          # Limit rename and copy detection
  --diff-filter: string               # Filter diff files
  -S: string                          # Look for differences in the occurance of <string>
  -G: string                          # Look for differences whose patch text contains <regex>
  --find-object: string               # Look for differences in the occurance of <object>
  --pickaxe-all                       # When -S or -G finds a change show all changes
  --pickaxe-regex                     # Treat the -S string as a POSIX regular expression
  -O: string                          # Control the order of files in the output
  --skip-to: string                   # Discard files before the named file
  --rotate-to: string                 # Moves files before the named file to the end
  -R                                  # Swap the inputs
  --relative: string                  # Only show changes relative to <path>
  --no-relative                       # Show all changes
  --text(-a)                          # Treat all files as text
  --ignore-cr-at-eol                  # Ignore CR at EOL
  --ignore-space-at-eol               # Ignore changes in whitespace at EOL
  --ignore-matching-lines(-I): string # Ignore changes whose lines match <regex>
  --inter-hunk-context: number        # Show up to <n> lines of context between diff hunks
  --function-context(-W)              # Show the whole function as change context
  --ext-diff                          # Allow an external diff helper
  --no-ext-diff                       # Disallow external diff helper
  --textconv                          # Allow external text conversion filters
  --no-textconv                       # Disallow external text conversion filters
  --ignore-submodules: string         # Ignore changes to submodules in diff generation
  --src-prefix: string                # Use the given source prefix
  --dst-prefix: string                # Use the given destination prefix
  --no-prefix                         # Do not show source or destination prefix
  --line-prefix: string               # Prepend a this to every line
  --ita-invisible-in-index
  --ita-visible-in-index
  --help                              # Show help
]

def stash [] {
  [
    "apply",
    "branch",
    "clear",
    "create",
    "drop",
    "list",
    "pop",
    "push",
    "show",
    "store",
  ]
}

# Stash changes in a dirty working directory
export extern "git stash" [
  command?: string@stash
  pathspec?: glob
  --patch(-p)                # Interactively add hunks of patch between the index and the work tree
  --staged(-S)
  -k
  --no-keep-index
  --quiet(-q)
  --include-untracked(-u)
  --all(-a)
  --message(-m): string
  --pathspec-from-file: string
  --pathspec-file-null
  --help                       # Show help
]

# Apply a single stashed state without removing it from the stash list
export extern "git stash apply" [
  --index
  --quiet(-q)
]

# Create a stash entry and return its objcet name
export extern "git stash create" [
  message?: string
]

# Clear all stash entries
export extern "git stash clear" [
]

# Remove a single stash entry
export extern "git stash drop" [
  --index
  --quiet(-q)
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
  stash?: string
  --index
  --quiet(-q)
]

# Save local modifications to a new stash entry
export extern "git stash push" [
  pathspec?: glob
  --patch(-p)                # Interactively add hunks of patch between the index and the work tree
  --staged(-S)
  -k
  --no-keep-index
  --quiet(-q)
  --include-untracked(-u)
  --all(-a)
  --message(-m): string
  --pathspec-from-file: string
  --pathspec-file-null
]

# Show changes record in the stash entry as a diff
export extern "git stash show" [
  stash: string
  --include-untracked(-u) # Show untracked files as part of the diff
  --only-untracked        # Show only the untracked files as part of the diff
]

#export extern "git status" [
#  ...pathspec: path             # Paths to get status for
#  --short(-s)                   # Use short format
#  --branch(-b)                  # Show branch and tracking info
#  --porcelain: number           # Use specified porcelain format
#  --porcelain                   # Use porcelain format
#  --long                        # Use long format
#  --verbose(-v)                 # Show staged changes to be committed
#  --untracked-files(-u)         # Show untracked files
#  --untracked-files(-u): string # Show untracked files
#  --ignore-submodules           # Ignore changes to submodules
#  --ignore-submodules: string   # Ignore changes to submodules
#  --ignored                     # Show ignored files
#  --ignored: string             # Show ignored files
#  -z                            # Terminate entries with NUL
#  --column                      # Display untracked files in columns
#  --column: string              # Display untracked files in columns
#  --no-column                   # Do not display untracked files in columns
#  --ahead-behind                # Display ahead/behind counts relative to upstream
#  --no-ahead-behind             # Do not display ahead/behind counts relative to upstream
#  --renames                     # Detect renames
#  --no-renames                  # Do not detect renames
#  --find-renames                # Find renames
#  --find-renames: number        # Find renames up to a similarity threshold
#  --help                        # Show help
#]

# Show the working tree status
export def "git status" (--ignored) {
  let $ignored = $ignored | into string

  git_status $ignored
  | select name status staged unstaged --ignore-errors
}

def submodule [] {
  [
    "add",
    "status",
    "init",
    "deinit",
    "update",
    "set-branch",
    "set-url",
    "summary",
    "foreach",
    "sync",
    "absorbgitdirs",
  ]
}

# Initialize, update, or inspect submodules
export extern "git submodule" [
  command: string@submodule
  --quiet
  --cached
  --help                       # Show help
]

# Show the status of submodules
export def "git submodule status" (--recursive) {
  submodule_status $recursive
  | update SHA { |r| $r.SHA | str substring 0..8 }
  | sort
}

# Switch branches
export extern "git switch" [
  branch?: string@branches_and_remotes # Branch to switch to
  start_point?: string
  --conflict: string@conflict_style # Like --merge, but show conflicting hunks
  --create(-c): string       # Create a new branch
  --detach(-d)               # Switch to a commit for inspection or experiments
  --discard-changes          # Proceed even if the index or working tree differs from HEAD
  --force(-f)                # Proceed even if the index or working tree differs from HEAD
  --force-create(-C): string # Create a new branch, but reset its start point
  --guess                    # Try to track a remote branch (default behavior)
  --ignore-other-worktrees   # Check out the ref even if checked out by another work tree
  --merge(-m)                # Merge local changes when switching branches
  --no-guess                 # Do not try to guess a tracking branch
  --no-progress              # Do not show progress
  --no-track                 # Do not set up upstream configuration
  --orphan: string           # Create a new orphan branch
  --progress                 # Report progress on stderr, even without a terminal
  --quiet(-q)                # Quiet
  --recurse-submodules       # Update active submodules
  --track(-t): string        # Set up upstream configuration when creating a branch
  --help                     # Show help
]

def cleanup_mode [] {
  [
    { value: "verbatim", description: "Do not change the message" }
    { value: "whitespace", description: "Remove leading and trailing whitespace lines" }
    { value: "strip", description: "Remove leading and trailing whitespace and comments" }
  ]
}

def _tags [] {
  git_tags | rename "value" "description"
}

# Create, list, delete, or verify a tag object
export def "git tag" [] {
  help git tag
}

# Create tag
export def "git tag create" [
  tagname: string                # New tag name
  commit?: string@commits        # Commit to tag
  --annotate(-a)                 # Make an unsigned, annotated tag object
  --cleanup: string@cleanup_mode # Specify how the tag message is cleaned up
  --edit(-e)                     # Edit message read from --file
  --file(-F): path               # Read message from file
  --force(-f)                    # Replace an existing tag
  --local-user(-u): string       # Use this key to make a GPG-signed tag
  --message(-m): string          # Set the tag message
  --no-sign                      # Disable GPG-signing
  --sign(-s)                     # Make a GPG-signed tag
] {
  mut args = []

  if $annotate {
    $args = ( $args | append ["--annotate"] )
  }

  if $edit {
    $args = ( $args | append ["--edit"] )
  }

  if $file != null {
    $args = ( $args | append ["--file" $file] )
  }

  if $force {
    $args = ( $args | append ["--force"] )
  }

  if $local_user != null {
    $args = ( $args | append ["--local-user" $local_user] )
  }

  if $message != null {
    $args = ( $args | append ["--message" $message] )
  }

  if $no_sign {
    $args = ( $args | append ["--no-sign"] )
  }

  if $sign {
    $args = ( $args | append ["--sign"] )
  }

  $args = ( $args | append [$tagname] )

  if $commit != null {
    $args = ( $args | append [$commit] )
  }

  let args = $args

  GIT_PAGER=cat run-external "git" "tag" $args
}

# Delete tags
export def "git tag delete" [
  ...tagname: string@_tags # Tags to delete
] {
  run-external "git" "tag" "-d" $tagname
}

def tag_column [] {
  [
    { value: "always", description: "Always show in columns" },
    { value: "never", description: "Never show in columns" }
  ]
}

# List tags
export def "git tag list" [
  ...pattern: string            # Tag patterns to match
  -n: number                    # Print lines from an annotation
  --column: string@tag_column   # Display tag list in columns
  --color: string@color         # Respect colors in --format output
  --contains: string@commits    # List tags with the given commit
  --create-reflog               # Create a reflog for the tag
  --format: string              # Format tag output
  --ignore-case(-i)             # Ignore case when sorting and filtering
  --merged: string              # List tags reachable from the given commit
  --no-column                   # Do not show columns
  --no-contains: string@commits # List tags without the given commit
  --no-merged: string@commits   # List tags not reachable from the given commit
  --points-at: string@commits   # List tags of the given object
  --sort: string                # Sort by key
] {
  mut args = []

  if $n != null {
    $args = ( $args | append ["-n" $n] )
  }

  if $column != null {
    $args = ( $args | append ["--column" $column] )
  }

  if $contains != null {
    $args = ( $args | append ["--contains" $contains] )
  }

  if $create_reflog != null {
    $args = ( $args | append ["--create-reflog"] )
  }

  if $format != null {
    $args = ( $args | append ["--format" $format] )

    if $color != null {
      $args = ( $args | append ["--color" $color] )
    }
  } else {
    $args = ( $args | append ["--format" "%(refname:strip=2)%00%(contents:subject)"] )
  }

  if $ignore_case {
    $args = ( $args | append ["--ignore-case"] )
  }

  if $merged != null {
    $args = ( $args | append ["--merged" $merged] )
  }

  if $no_column != null {
    $args = ( $args | append ["--no-column"] )
  }

  if $no_contains != null {
    $args = ( $args | append ["--no_contains" $no_contains] )
  }

  if $no_merged != null {
    $args = ( $args | append ["--no-merged" $no_merged] )
  }

  if $points_at != null {
    $args = ( $args | append ["--points-at" $points_at] )
  }

  if $sort != null {
    $args = ( $args | append ["--sort" $sort] )
  }

  let args = ( $args | append $pattern )

  let result = GIT_PAGER=cat run-external --redirect-stdout "git" "tag" "-l" $args

  if $format == null {
    $result
    | lines
    | each {||
      $in
      | split column "\u{0}"
    }
    | flatten
    | rename tag subject
  } else {
    $result
  }
}

# Verify GPG signatures of tags
export def "git tag verify" [
  ...tagname: string@_tags # Tags to verify
  --format: string         # Format tag output
] {
  mut args = []

  if $format != null {
    $args = ( $args | append ["--format" $format] )
  } else {
    $args = ( $args | append ["--format" "%(refname:strip=2)%00%(contents:subject)"] )
  }

  let args = ( $args | append $tagname )

  GIT_PAGER=cat run-external "git" "tag" "-v" $args
}
