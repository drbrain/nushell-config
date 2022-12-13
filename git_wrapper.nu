module git_wrapper {
  def commits_parse_line [line: string] {
    ( $line
    | split column "\u0000"
    | rename ref author date subject
    )
  }

  export def commits [] {
    let args = [
      "log",
      "--pretty=format:%H%x00%an%x00%aI%x00%s",
    ]

    ( GIT_PAGER=cat run-external --redirect-stdout "git" $args
    | lines
    | par-each { |line| commits_parse_line $line }
    )
  }

  def match [input, matchers: record] {
      ( echo $matchers
      | get $input
      | do $in
      )
  }

  # Parses most of `git status --porcelain=2`
  #
  # This does not parse the `<sub>` field containing the submodule status
  #
  # This does not parse the `<X><score>` field containing the rename/copy similarity status
  def parse_line [line: string] {
    let line = ( $line | split row " " )
    let status = $line.0

    match $status {
      "?": {
        ( {}
        | insert name $line.1
        | insert status "untracked"
        | insert staged "untracked"
        | insert unstaged "untracked"
        )
      },
      "!": {
        ( {}
        | insert name $line.1
        | insert status "ignored"
        | insert staged "untracked"
        | insert unstaged "untracked"
        )
      },
      "1": {
        let states = parse_states $line.1

        ( {}
        | insert name $line.8
        | insert status "changed"
        | insert staged $states.staged
        | insert unstaged $states.unstaged
        | insert mode_head $line.3
        | insert mode_index $line.4
        | insert mode_worktree $line.5
        | insert name_head $line.6
        | insert name_index $line.7
        )
      },
      "2": {
        let paths = parse_rename_path $line.9
        let states = parse_states $line.1

        ( {}
        | insert status "renamed"
        | insert name $paths.0
        | insert staged $states.staged
        | insert unstaged $states.unstaged
        | insert mode_head $line.3
        | insert mode_index $line.4
        | insert mode_worktree $line.5
        | insert name_head $line.6
        | insert name_index $line.7
        | insert original_name $paths.1
        )
      },
      "u": {
        let states = parse_states $line.1

        ( {}
        | insert status "unmerged"
        | insert name $line.10
        | insert staged $states.staged
        | insert unstaged $states.unstaged
        | insert mode_stage_1 $line.3
        | insert mode_stage_2 $line.4
        | insert mode_stage_3 $line.5
        | insert mode_worktree $line.6
        | insert name_stage_1 $line.7
        | insert name_stage_2 $line.8
        | insert name_stage_3 $line.9
        )
      }
    }
  }

  # Paths for a rename record are separated by a tab character
  def parse_rename_path [paths: string] {
    ( $paths
    | split row "\t" )
  }

  # State marker
  def parse_state [state: string] {
    match $state {
      ".": { "unmodified" },
      "M": { "modified" },
      "T": { "type changed" },
      "A": { "added" },
      "D": { "deleted" },
      "R": { "renamed" },
      "C": { "copied" },
      "U": { "updated" }
    }
  }

  # States field contains the staged and unstaged status of an object
  def parse_states [states: string] {
    let states = ( $states | split chars )

    let staged = parse_state $states.0
    let unstaged = parse_state $states.1

    { staged: $staged, unstaged: $unstaged }
  }

  export def status [ignored: bool] {
    let args = ["status", "--porcelain=2"]
    let args = if $ignored {
      ($args | append "--ignored")
    } else {
      $args
    }

    ( run-external --redirect-stdout "git" $args
    | lines
    | each { |line| parse_line $line }
    )
  }
}
