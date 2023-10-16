def cargo_wrapper (...args: string) {
  run-external --redirect-stdout "cargo" $args
}

export def list_installed [] {
  ( cd # Avoid notes and warnings from a Cargo.toml
  | cargo_wrapper "install" "--list"
  | lines
  | where {|l| $l !~ '^\s' }
  | parse -r '(?<package>.*?) (?<version>v[^: ]+)(?: \((?<path>.*?)\))?:'
  )
}
