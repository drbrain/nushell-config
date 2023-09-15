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
          $item not-in $seen
        }

    $todo = ($todo | append $new)
  }

  $config_files
}

def hosts [] {
  config_files
  | par-each {|file|
      open $file
      | lines
      | find -r '^\s*Host(?:name)?\s'
      | parse -r '^\s*Host(?:name)?\s(?<hosts>.*)'
      | get hosts
      | split column ' '
      | values
      | flatten
      | uniq
      | filter {|host|
          not (
            ( $host | str starts-with "!" ) or
            ( $host =~ '\*|%' )
          )
        }
    }
  | flatten
  | uniq
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
  | par-each {|include|
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

def known_hosts [] {
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
  | par-each {|file|
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

# Hosts listed in SSH config files
#
# Includes Host, HostName, GlobalKnownHostsFile and UserKnownHostsFile entries
# that do not contain wildcards
export def ssh_hosts [] {
  let $hosts = hosts
  let $known_hosts = known_hosts

  $hosts
  | append $known_hosts
  | uniq
  | sort
}
