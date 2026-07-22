def rustup_wrapper (...args: string) {
  run-external "rustup" $args
}

export def list_components [] {
  run-external "rustup" "component" "list"
  | lines
  | each {
    parse -r '(?<component>[^ ]+?)(?: \((?<installed>[^)]+)\))?$'
  }
  | flatten
  | upsert installed { |l| $l.installed == "installed" }
  | select component installed
  | sort-by installed component
}

export def list_toolchains [] {
  run-external "rustup" "toolchain" "list" "-v"
  | lines
  | each {
    parse -r '(?<toolchain>.*?)(?: \((?<attributes>[^)]+)\))? (?<path>.*)'
  }
  | flatten
  | upsert active { |l| $l.attributes == "active" }
  | upsert default { |l| $l.attributes == "default" }
  | select toolchain active default path
}

