export def config_files [] {
  mut todo = [
    '/etc/ssh/ssh_config'
    ('~/.ssh/config' | path expand),
  ]

  mut config_files = []

  while ( $todo | length ) > 0 {
    let next = $todo | first
    $todo = ($todo | drop nth 0)

    $config_files = ($config_files | append $next)

    let seen = $config_files
    let found = included $next

    let new = $found
      | filter {|item|
          $seen | all {|cf| $cf != $item }
        }

    $todo = ($todo | append $new)
  }

  $config_files
}

def included [config: path] {
  let base = $config | path dirname

  open $config
  | lines
  | find -r '^\s*Include\s'
  | parse -r '^\s*Include\s+(?<includes>.*)'
  | get includes
  | split column ' '
  | values
  | flatten
  | uniq
  | each {|include|
      let glob = if ( $include | str starts-with '/' ) {
        $include
      } else if ( $include | str starts-with '~' ) {
        $include | path expand
      } else {
        $base | path join $include
      }

      do -s {
        ls $glob
        | get name
      }
  }
  | flatten
  | uniq
}

export def known_hosts [] {
  let files = known_hosts_files

  $files
  | par-each {|file|
      $file
      | open
      | lines
      | find -v -r '@|#|\|'
      | split column ' '
      | flatten
      | get column1
      | split column ','
      | flatten
      | values
      | flatten
      | uniq
    }
    | flatten
    | uniq
  | flatten
}

def known_hosts_files [] {
  config_files
  | each {|file|
      known_hosts_files_in $file
    }
  | flatten
  | uniq
}

def known_hosts_files_in [config: path] {
  open $config
  | lines
  | find -r '^\s*(?:User|Global)KnownHostsFile\s'
  | parse -r '^\s*(?:User|Global)KnownHostsFile\s+(?<files>.*)'
  | get files
  | split column ' '
  | values
  | flatten
  | uniq
  | filter {||
    $in | path exists
  }
}
