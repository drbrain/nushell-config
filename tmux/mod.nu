export def update_environment [] {
  let tmux_env = do { tmux show-environment } | complete

  if $env.LAST_EXIT_CODE == 0 {
    $env.SSH_AUTH_SOCK = (
      $tmux_env
      | get stdout
      | lines
      | filter { |l| $l | str contains "=" }
      | parse "{name}={value}"
      | find SSH_AUTH_SOCK
      | get value
      )
  }
}
