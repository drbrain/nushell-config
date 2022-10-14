# From https://github.com/nushell/nu_scripts/blob/main/filesystem/cdpath.nu
# which is under the MIT license
#
# You must set $env.CDPATH, try:
#
#     let-env CDPATH = [
#       ".",
#       "~",
#       "~/path/to/repositories",
#     ]
#
# This will complete:
# * Entries under the current directory ($env.PWD)
# * Entries in your home directory ($env.HOME)
# * Entries where you check out repositories

# Completion for `c`
def cdpath_complete [] {
  ( $env.CDPATH
  | path expand
  | each { |dir|
      ( ls $dir
      | where type == "dir"
      | get name
      )
    }
  | flatten
  | path basename
  | uniq
  | sort
  )
}

def-env c [dir = "": string@cdpath_complete] {
  let span = (metadata $dir).span
  let default = $env.HOME

  let complete_dir = if $dir == "" {
    $default
  } else {
    $env.CDPATH
    | path expand
    | reduce -f "" { |$it, $acc|
        if $acc == "" {
          let new_path = ([$it $dir] | path join)
          if ($new_path | path exists) {
            $new_path
          } else {
            ""
          }
        } else {
          $acc
        }
      }
  }

  let complete_dir = if $complete_dir == "" {
    error make {
      msg: "No such directory under any $env.CDPATH entry",
      label: {
        text: "This directory",
        start: $span.start,
        end: $span.end,
      }
    }
  } else {
    $complete_dir
  }

  let-env PWD = $complete_dir
}
