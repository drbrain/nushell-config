export def panes [] {
  run-external "wezterm" "cli" "list" "--format" "json"
  | from json
  | each {|pane|
    {
      value: $pane.pane_id
      description: $"($pane.tty_name) ($pane.title) \(($pane.size.rows)x($pane.size.cols)\)"
    }
  }
  | uniq
}

export def tabs [] {
  run-external "wezterm" "cli" "list" "--format" "json"
  | from json
  | each {|tab|
    {
      value: $tab.tab_id
      description: $"($tab.tty_name) ($tab.tab_title) \(($tab.size.rows)x($tab.size.cols)\)"
    }
  }
  | uniq
}

export def windows [] {
  run-external "wezterm" "cli" "list" "--format" "json"
  | from json
  | each {|window|
    {
      value: $window.window_id
      description: $"($window.tty_name) ($window.window_title) \(($window.size.rows)x($window.size.cols)\)"
    }
  }
  | uniq
}
