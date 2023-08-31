use wrapper tmux *

def commands [] {
  ( list_commands
  | get command alias
  | flatten
  | sort
  )
}

# Terminal multiplexer
export extern main [
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

export def "tmux show-environment" () {
  ( environment
  | sort
  )
}

# buffers

def buffer [] {
  list_buffers | get name
}

# Delete a buffer
export extern "tmux delete-buffer" [
  -b: string@buffer # Buffer to delete
]

# List global buffers
export def "tmux list-buffers" () {
  ( list_buffers
  | sort
  )
}

# Show a buffer
export extern "tmux show-buffer" [
  -b: string@buffer # Buffer to show
]

