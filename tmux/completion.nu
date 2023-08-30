use wrapper.nu *

def commands [] {
  ( list_commands
  | get command alias
  | flatten
  | sort
  )
}

# Terminal multiplexer
export extern "tmux" [
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
  command: string@commands
  command_flags?: list
]

export def "tmux list-commands" () {
  ( list_commands
  | get command
  | sort
  )
}

export def "tmux list-sessions" () {
  ( list_sessions
  | move attached --after name
  )
}
