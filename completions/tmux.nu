module tmux_wrapper {
  def tmux (...args: string) {
    run-external --redirect-stdout "tmux" $args
  }

  export def list_commands [] {
    ( tmux "list-commands"
    | lines
    | parse -r "(?<command>[\\w-]+) (?:\\((?<alias>\\w+)\\) )?(?<flags>.*)"
    )
  }

  export def list_sessions [] {
    ( tmux "list-sessions"
    | lines
    | parse "{name}: {windows} windows (created {created}) ({attached})"
    | update created { |r|
      $r.created | into datetime
    }
    )
  }
}

module completions_tmux {
  use tmux_wrapper

  def commands [] {
    ( tmux_wrapper list_commands
    | get command alias
    | flatten
    | sort
    )
  }

  export extern "tmux" [
    command: string@commands
    flags?: list
    -2         # Force 256 color terminal support
    -C         # Start in control mode, twice disables echo
    -c: string # Execute a shell command using the default shell
    -f: path   # Use an alternate configuration file
    -L: path   # Use an alternate socket directory
    -l         # Behave as a login shell
    -s: path   # Use an alternative server socket
    -u         # Force UTF-8
    -v         # Request verbose logging
    -V         # Version
  ]

  export def "tmux list-commands" () {
    ( tmux_wrapper list_commands
    | get command
    | sort
    )
  }

  export def "tmux list-sessions" () {
    ( tmux_wrapper list_sessions
    | move attached --after name
    )
  }
}

use completions_tmux *
