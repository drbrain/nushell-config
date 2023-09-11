def tmux_wrapper (...args: string) {
  run-external --redirect-stdout "tmux" $args
}

export def environment [] {
  ( tmux_wrapper "show-environment"
  | lines
  | each { |l|
      if ($l | str contains "=") {
        $l | parse "{name}={value}"
      } else {
        $l | parse "-{name}"
      }
    }
  | flatten
  )
}

export def has_session [] -> bool {
  let exit_code = do { ^tmux has-session } | complete | get exit_code

  $exit_code == 0
}

export def list_commands [] {
  ( tmux_wrapper "list-commands"
  | lines
  | parse -r "(?<command>[\\w-]+) (?:\\((?<alias>\\w+)\\) )?(?<flags>.*)"
  )
}

export def list_buffers [] {
  ( tmux_wrapper "list-buffers"
  | lines
  | parse -r "(?<name>.*?): .*? bytes: \\"(?<data>.*)\\""
  )
}

export def list_keys [table?: string] {
  let keys = if $table == null {
    tmux_wrapper list-keys
  } else {
    tmux_wrapper list-keys "-T" $table
  }

  $keys
  | lines
  | parse -r "bind-key (?<repeat>-r)?\\s+-T (?<table>\\S+)\\s+(?<key>\\S+)\\s+(?<command>\\S+)(?: (?<arguments>.*))?"
  | update repeat { |r| $r.repeat == "-r" }
  | move table --after arguments
  | move repeat --after table
}

export def list_sessions [] {
  ( tmux_wrapper "list-sessions"
  | lines
  | parse "{name}: {windows} windows (created {created}) ({attached})"
  | update created { |r|
    $r.created | into datetime
  }
  )
}

# Update the nushell environment from tmux
export def update-environment [] {
  if (has_session) {
    environment
    | into record
    | load-env
  }
}
