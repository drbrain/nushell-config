def rustup_wrapper (...args: string) {
  run-external "rustup" $args
}

export def list_toolchains [] {
  run-external "rustup" "toolchain" "list" "-v"
  | lines
  | each {
    parse -r '(?<toolchain>.*?)(?: \((?<attributes>[^)]+)\))? (?<path>.*)'
  }
  | flatten
  | upsert active { |l| $l.attributes =~ "active" }
  | upsert default { |l| $l.attributes =~ "default" }
  | select toolchain path active default
}

