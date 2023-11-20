export def config_type [] {
  [
    { value: "bool", description: "true or false" },
    { value: "bool-or-int", description: "bool or int" },
    { value: "color", description: "Expressible as an ANSI color" },
    { value: "expiry-date", description: "Fixed or relative date" },
    { value: "int", description: "Decimal number with an optional k, m, g suffix" },
    { value: "path", description: "Path to a file" },
  ]
}

export def conflict_style [] {
  [
    { value: "merge", description: "RCS style" },
    { value: "diff3", description: "RCS style with base hunk" },
    { value: "zdiff3", description: "diff3 omitting common lines in the conflict" },
  ]
}

export def decorate () {
  [
    { value: "auto", description: "Short ref names for TTY output" },
    { value: "full", description: "Include ref prefixes" },
    { value: "no", description: "Don't decorate" },
    { value: "short", description: "Omit refs/* prefixes" },
  ]
}

export def diff_algorithm [] {
  [
    "default",
    "histogram",
    "minimal",
    "myers",
    "patience",
  ]
}

export def mirror [] {
  [ "fetch", "push" ]
}

export def rebase_arg [] {
  [
    { value: "false", description: "Do not rebase" },
    { value: "interactive", description: "Interactive rebase" },
    { value: "merges", description: "Include local merge commits in the rebase" },
    { value: "true", description: "Rebase atop the upstream branch after fetching" },
  ]
}

export def recurse_submodules [] {
  [
    { value: "yes", description: "Recurse into all populated submodules" },
    { value: "on-demand", description: "Recurse into changed submodules" },
    { value: "no", description: "Do not recurse into submodules" },
  ]
}

