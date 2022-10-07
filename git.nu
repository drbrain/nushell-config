module git {
  # Parses most of `git status --porcelain=2`
  #
  # This does not parse the `<sub>` field containing the submodule status
  #
  # This does not parse the `<X><score>` field containing the rename/copy similarity status
  def parse_line [line: string] {
    let record = {}
    let line = ( $line | split row " " )
    let status = $line.0

    let record = if $status == "?" {
      ( $record
      | insert name $line.1
      | insert status "untracked"
      )
    } else if $status == "!" {
      ( $record
      | insert name $line.1
      | insert status "ignored"
      )
    } else if $status == "1" {
      ( $record
      | insert name $line.8
      | insert status "changed"
      | merge { parse_states $line.1 }
      | insert mode_head $line.3
      | insert mode_index $line.4
      | insert mode_worktree $line.5
      | insert name_head $line.6
      | insert name_index $line.7
      )
    } else if $status == "2" {
      let paths = parse_rename_path $line.9
      ( $record
      | insert status "renamed"
      | insert name $paths.0
      | merge { parse_states $line.1 }
      | insert mode_head $line.3
      | insert mode_index $line.4
      | insert mode_worktree $line.5
      | insert name_head $line.6
      | insert name_index $line.7
      | insert original_name $paths.1
      )
    } else if $status == "u" {
      ( $record
      | insert status "unmerged"
      | insert name $line.10
      | merge { parse_states $line.1 }
      | insert mode_stage_1 $line.3
      | insert mode_stage_2 $line.4
      | insert mode_stage_3 $line.5
      | insert mode_worktree $line.6
      | insert name_stage_1 $line.7
      | insert name_stage_2 $line.8
      | insert name_stage_3 $line.9
      )
    }

    $record
  }

  # Paths for a rename record are separated by a tab character
  def parse_rename_path [paths: string] {
    ( $paths
    | split row "\t" )
  }

  # State marker
  def parse_state [state: string] {
    if $state == "." {
      "unmodified"
    } else if $state == "M" {
      "modified"
    } else if $state == "T" {
      "type changed"
    } else if $state == "A" {
      "added"
    } else if $state == "D" {
      "deleted"
    } else if $state == "R" {
      "renamed"
    } else if $state == "C" {
      "copied"
    } else if $state == "U" {
      "updated"
    }
  }

  # States field contains the staged and unstaged status of an object
  def parse_states [states: string] {
    let states = ( $states | split chars )

    let staged = parse_state $states.0
    let unstaged = parse_state $states.1

    { staged: $staged, unstaged: $unstaged }
  }

  export def status [] {
    ( ^git status --porcelain=2
    | lines
    | each { |line| parse_line $line }
    )
  }
}

