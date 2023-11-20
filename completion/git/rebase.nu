use wrapper git *

def comp_empty [] {
  [
    { value: drop, description: "Empty commits are dropped" },
    { value: keep, description: "Empty commits are kept" },
    { value: ask, description: "Stop and ask when empty" },
  ]
}

# Configure and start a rebase
#
# A rebase reapplies commits on top of another base tip
export extern "git rebase" [
  upstream?: string@git_branches_and_remotes # Upstream branch to compare against
  branch?: string@git_comp_local_branches    # working branch (default: HEAD)
  --onto: string@git_comp_local_branches     # Starting point for creating new commits
  --keep-base                                # Set the starting point for creating new commits to the merge base of (upstream) and (branch)
  --apply                                    # Use applying strategies to rebase
  --empty: string@comp_empty                 # How to handle commits that become empty after rebasing
  --keep-empty                               # Keep empty commits when rebasing starts
  --no-keep-empty                            # Do not keep empty commits when rebasing starts
  --reapply-cherry-picks                     # Reapply all clean cherry-picks of any upstream commit
  --no-reapply-cherry-picks                  # Do not reapply clean cherry-picks
  --merge(-m)                                # Use merging strategies to rebase
  --strategy(-s): string                     # Use the given merge strategy instead of the default of ort
  --strategy-option(-X): string              # Set a merge strategy-specific option
  --rerere-autoupdate                        # Allow rerere to update the index
  --no-rerere-autoupdate                     # Do not allow rerere to update the index
  --gpg-sign(-S): string                     # GPG-sign commits
  --no-gpg-sign                              # Do not GPG-sign commits
  --quiet(-q)                                # Suppress output
  --verbose(-v)                              # Be verbose
  --stat                                     # Show diffstat
  --verify                                   # Run pre-merge and commit-msg hooks
  --no-verify                                # Skip pre-merge and commit-msg hooks
  -C: int                                    # Show this many context lines
  --force-rebase(-f)                         # Replay all commits instead of fast-forwarding over unchanged ones
  --no-ff                                    # Replay all commits instead of fast-forwarding over unchanged ones
  --fork-point                               # Use reflog to find a better common ancestor between (upstream) and (branch)
  --no-fork-point                            # Do not try to find a better common ancestor
  --ignore-whitespace                        # Ignore whitespace differences when trying to reconcile differences
  --whitespace: string                       # Detect a new or modified line with whitespace errors (see git-apply)
  --committer-date-is-author-date            # Use the auther date of the commit being rebased as the committer date
  --ignore-date                              # Use the current time as the author date for rebased commits
  --reset-author-date                        # Use the current time as the author date for rebased commits
  --signoff)                                 # Add signed-off-by
  --interactive(-i)                          # Make an editable list of commits to rebase
  --rebase-merges(-r): string                # Try to preserve branching structure in rebased commits
  --no-rebase-merges                         # Place rebased commits in a single linear branch
  --exec(-x): string                         # Append `exec (cmd)` after each line creating a commit
  --root                                     # Rebase all commits reachable from (branch)
  --autosquash                               # Automatically modifiy the interactive todo list for squashable changes
  --no-autosquash                            # Do not autosquash
  --autostash                                # Create a temporary stash entry before rebasing and apply it at the end
  --no-autostash                             # Do not autostash
  --reschedule-faild-exec                    # Reschedule exec commands that failed
  --no-reschedule-faild-exec                 # Do not reschedule exec commands that failed
  --update-refs                              # Automatically force-update any branches that point to rebased commits
  --no-update-refs                           # Do not update branches that point to rebased commits
  --help                                     # Show help
]

# Abort rebasing and reset HEAD to the original branch
export def "git rebase abort" [] {
  ^git rebase --abort
}

# Restart the rebasing process after having resolved a merge conflict
export def "git rebase continue" [] {
  ^git rebase --continue
}

# Edit the todo list during interactive rebase
export def "git rebase edit-todo" [] {
  ^git rebase --edit-todo
}

# Show the current patch when the rebase is stopped
export def "git rebase show-current-patch" [] {
  ^git rebase --show-current-patch
}


# Restart rebasing after skipping the current patch
export def "git rebase skip" [] {
  ^git rebase --skip
}

# Abort rebasing but HEAD is not reset to the original branch
export def "git rebase quit" [] {
  ^git rebase --quit
}

