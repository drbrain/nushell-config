def brew_wrapper (...args: string) {
  run-external "brew" ...$args
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

def outated_to_completion [type] {
  $in
  | insert description {|r|
    $"($r.installed_versions | first) → ($r.current_version) \(($type)\)"
  }
  | select name description
  | rename value description
}

export def list_outdated [] {
  let outdated = brew_wrapper "outdated" "--json"
  | from json

  let casks = $outdated
  | get casks
  | outated_to_completion "cask"

  let formulae = $outdated
  | get formulae
  | outated_to_completion "formula"

  $casks
  | append $formulae
}
