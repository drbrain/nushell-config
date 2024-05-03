def cargo_wrapper (...args: string) {
  run-external "cargo" $args
}

export def dependencies [] {
  try {
    ls ~/.cargo/bin/cargo-deps-list
  } catch {
    print -e $"(ansi red_bold)NOTE:(ansi reset) Install cargo-dep-list"
    return []
  }

  run-external "cargo" "deps-list"
  | lines
  | where {|| $in !~ "^Total dependencies:|^$" }
  | parse -r '(?<package>.*?) v(?<version>.*?) \{(?<features>.*?)\}'
  | upsert features {|| $in.features | split row ',' }
}

export def list_dependencies [] {
  dependencies
  | each {||
    {
      value: $"($in.package)@($in.version)"
      description: $"features: ($in.features | str join ' ')"
    }
  }
}

export def list_installed [] {
  cd # Avoid notes and warnings from a Cargo.toml
  | cargo_wrapper "install" "--list"
  | lines
  | where {|l| $l !~ '^\s' }
  | parse -r '(?<package>.*?) (?<version>v[^: ]+)(?: \((?<path>.*?)\))?:'
}
