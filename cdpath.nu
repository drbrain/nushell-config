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
  # $env.CDPATH with unique, expanded, existing paths
  def cdpath [] {
    $env.CDPATH
    | path expand
    | uniq
    | filter {|| $in | path exists }
  }

  def children [path: string] {
    ls -a $path
    | where type == "dir"
    | get name
    | path basename
    | sort
  }

  # Completion for `c`
  def complete [context: string] {
    let context_dir = $context | parse "c {context_dir}" | get context_dir | first
    let path = $context_dir | path split
    let no_trailing_slash = not ($context_dir | str ends-with "/")

    # completion with no context
    if ( $path | is-empty ) {
      complete_from_cdpath
    # Chosing an entry directly under CDPATH
    #
    # This appends a / to allow continuation to the last step
    } else if (1 == ( $path | length )) and $no_trailing_slash {
      let first = $path | first

      complete_from_cdpath
      | filter {|| $in.value | str contains $first }
      | upsert value {|| $"($in.value)/" }
    # Chosing some child under a CDPATH entry
    } else {
      let prefix = if 1 == ($path | length) {
        $path | first
      } else {
        $path | first (($path | length) - 1) | path join
      }

      let last = if 1 == ($path | length) {
        ""
      } else {
        $path | last
      }
      
      let chosen_path = cdpath
      | each {||
        $in | path join $prefix
      }
      | filter {||
        $in | path exists
      }
      | first

      children $chosen_path
      | filter {||
        $in | str contains $last
      }
      | each {|child|
        $chosen_path | path join $child
      }
    }
  }

  def complete_from_cdpath [] {
    cdpath
    | each { |path|
      children $path
      | each { |child| { value: $child, description: $path } }
    }
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
    } else if ( $dir | str starts-with "~" ) {
      $dir
    } else {
      cdpath
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
