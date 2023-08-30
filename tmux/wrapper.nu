def tmux_wrapper (...args: string) {
  run-external --redirect-stdout "tmux" $args
}

export def list_commands [] {
  ( tmux_wrapper "list-commands"
  | lines
  | parse -r "(?<command>[\\w-]+) (?:\\((?<alias>\\w+)\\) )?(?<flags>.*)"
  )
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
