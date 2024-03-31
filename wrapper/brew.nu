def brew_wrapper (...args: string) {
  run-external --redirect-stdout "brew" $args
}

export def list_installed [] {
  brew_wrapper "list" "-1"
  | lines
  | sort
}
