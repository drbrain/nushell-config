let environment = do { tmux show-environment } | complete

if $env.LAST_EXIT_CODE == 0 {
  $env.SSH_AUTH_SOCK = (
    $environment
    | get stdout
    | lines
    | filter { |l| $l | str contains "=" }
    | parse "{name}={value}"
    | find SSH_AUTH_SOCK
    | get value
    )
}
  
