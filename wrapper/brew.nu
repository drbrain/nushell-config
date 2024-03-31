def brew_wrapper (...args: string) {
  run-external --redirect-stdout "brew" $args
}

export def description [formula: string] {
  brew_wrapper "info" "--json" $formula
  | from json
}

export def list_casks [] {
  brew_wrapper "casks"
  | lines
  | sort
}

export def list_checks [] {
  brew_wrapper "doctor" "--list-checks"
  | lines
}

export def list_formulae [] {
  brew_wrapper "formulae"
  | lines
  | sort
}

export def list_installed [] {
  brew_wrapper "list" "-1"
  | lines
  | sort
}
