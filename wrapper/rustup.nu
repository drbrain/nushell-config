def rustup_wrapper (...args: string) {
  run-external "rustup" $args
}

export def list_toolchains [] {
  ( run-external "rustup" "toolchain" "list" "-v"
  | lines
  | each { |l|
    $l | parse -r '(?<toolchain>.*?)(?: \((?:(?<default>default)|(?<override>override))\))?\t(?<path>.*)'
  }
  | flatten
  | upsert override { |i| $i.override == "override" }
  | upsert default { |i| $i.default == "default" }
  )
}

