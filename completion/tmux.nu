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

# List all tmux commands
export def "tmux list-commands" () {
  ( list_commands
  | get command
  | sort
  )
}

# List all sessions managed by the server
export def "tmux list-sessions" () {
  ( list_sessions
  | move attached --after name
  )
}

# Display the tmux environment
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

# keys

# Bind a key to a command
export extern "tmux bind-key" [
  -n                       # Bind in the root table
  -r                       # Allow repeat
  -T: string               # Bind key in a table
  key: string              # Key to bind
  command: string@commands # Command to run
  ...arguments             # Command arguments
]

# List bound keys
export def "tmux list-keys" (-T: string) {
  let table = if $T == null {
    "prefix"
  } else {
    $T
  }

  list_keys $table
  | sort-by table key command
}

# Send a key or keys to a window
export extern "tmux send-keys" [
  -H         # Key is hexadecimal
  -l         # Key is literal
  -M         # Pass through mouse event
  -R         # Reset terminal state
  -X         # Send a command into copy mode
  -N: int    # Repeate the key
  -t: string # Send key to a pane
  ...keys    # Keys to send
]

# Send the prefix key
export extern "tmux send-prefix" [
  -2         # Send the secondary key prefix
  -t: string # Send prefix to a pane
]

# Unbind a key
export extern "tmux unbind-key" [
  -a          # Remove all bindings
  -n          # Unbind key in the root table
  -t: string  # Unbind key in a table
  key: string # Key to unbind
]
