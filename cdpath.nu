# From https://github.com/nushell/nu_scripts/blob/main/filesystem/cdpath.nu
# which is under the MIT license
#
# You must set $env.CDPATH, try:
#
#     $env.CDPATH = [
#       ".",
#       "~",
#       "~/path/to/repositories",
#     ]
#
# The above $env.CDPATH will complete:
# * Entries under the current directory ($env.PWD)
# * Entries in your home directory ($env.HOME)
# * Entries where you check out repositories

module cdpath {
  # Completion for `c`
  def complete [] {
    ( $env.CDPATH
      | path expand
      | filter { || $in | path exists }
      | each { |path|
      let children = (
          ls -a $path
          | where type == "dir"
          | get name
          | path basename
          | sort
          )

      $children | each { |child| { value: $child, description: $path } }
      }
    )
      | flatten
      | uniq-by value
  }

  # Change directory with $env.CDPATH
  export def-env c [dir = "": string@complete] {
    let span = (metadata $dir).span
      let default = if $nu.os-info.name == "windows" {
        $env.USERPROFILE
      } else {
        $env.HOME
      }

    let target_dir = if $dir == "" {
      $default
    } else if $dir == "-" {
      if "OLDPWD" in $env {
        $env.OLDPWD
      } else {
        $default
      }
    } else {
      $env.CDPATH
        | path expand
        | filter { || $in | path exists }
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

    let target_dir = if $target_dir == "" {
      let cdpath = $env.CDPATH | str join ", "

      error make {
        msg: $"No such child under: ($cdpath)",
        label: {
          text: "Child directory",
          start: $span.start,
          end: $span.end,
        }
      }
    } else {
      $target_dir
    }

    cd $target_dir
  }
}

use cdpath c
