# Adapted from original by Yorick Sijsling
# Adapted from bash version by Rob Miller <rob@bigfish.co.uk>

# Delete local (and optionally remote) merged branches
export def "git cleanup-repo" [
  upstream: string = "origin" # Upstream remote repository
] {
  let default_branch = get_default_branch $"refs/remotes/($upstream)/HEAD"
  let keep = get_keep

  # Switch to the default branch
  switch_branch $default_branch

  # Make sure we're working with the most up-to-date version of the default
  # branch.
  run-external "git" "fetch"

  # Prune obsolete remote tracking branches. These are branches that we
  # once tracked, but have since been deleted on the remote.
  run-external "git" "remote" "prune" $upstream

  # Delete local branches that have been fully merged into the default branch
  list_merged $upstream $default_branch $keep
  | each {|branch|
    delete_local $branch
  }

  # Again with remote branches
  let merged_on_remote = list_merged --remote $upstream $default_branch $keep

  if not ( $merged_on_remote | is-empty ) {
    print "The following remote branches are fully merged and will be removed:"

    $merged_on_remote
    | each {||
      print $"\t($in)"
    }

    print ""

    if ( input --suppress-output "Continue (y/N)? " | str trim ) == "y" {
      $merged_on_remote
      | each {|branch|
        delete_remote $upstream $branch
      }
    }
  }

  switch_branch $default_branch
}

def delete_local [
  branch: string
] {
 run-external "git" "branch" "--delete" $branch
}

def delete_remote [
  upstream: string
  branch: string
] {
  run-external "git" "push" "--quiet" "--delete" $upstream $branch
}

def get_default_branch [
  upstream: string
] {
  let args = [
    "--short"
    $upstream
  ]

  run-external --redirect-stdout "git" "symbolic-ref" $args
  | str trim
  | path basename
}

def get_keep [] {
  let keep = run-external --redirect-stdout "git" "config" "--local" "--get" "cleanup-repo.keep"

  if ( $keep | is-empty ) {
    return []
  }

  $keep
  | str trim
  | split column " "
  | get column1
}

# List all the branches that have been merged fully into the default branch.
#
# We use the remote default branch here, just in case our local default branch is out of date.
def list_merged [
  --remote
  upstream: string
  branch: string
  keep: list<string>
] {
  mut args = [
    "--list"
    "--merged" $"($upstream)/($branch)"
  ]

  if $remote {
    $args = ( $args | append [
      "--format" "%(refname:lstrip=3)"
      "--remote"
    ])
  } else {
    $args = ( $args | append [
      "--format" "%(refname:lstrip=2)"
    ])
  }

  let args = $args

  let keep = (
    $keep
    | append [
      "HEAD",
      $branch,
    ]
  )

  run-external --redirect-stdout "git" "branch" $args
  | lines
  | filter {|branch|
      $keep
      | all {|pattern|
        $branch !~ $'\A($pattern)\z'
      }
  }
}

def switch_branch [
  branch: string
] {
  let args = [
    "--quiet"
    "--no-guess"
    $branch
  ]

  run-external "git" "switch" $args
}
