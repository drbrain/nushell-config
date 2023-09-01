# Tokyonight-night theme colors
export def-env night () {
  let bg = "#1a1b26"
  let bg_dark = "#16161e"
  let bg_highlight = "#292e42"
  let blue = "#7aa2f7"
  let blue0 = "#3d59a1"
  let blue1 = "#2ac3de"
  let blue2 = "#0db9d7"
  let blue5 = "#89ddff"
  let blue6 = "#b4f9f8"
  let blue7 = "#394b70"
  let comment = "#565f89"
  let cyan = "#7dcfff"
  let dark3 = "#545c7e"
  let dark5 = "#737aa2"
  let fg = "#c0caf5"
  let fg_dark = "#a9b1d6"
  let fg_gutter = "#3b4261"
  let green = "#9ece6a"
  let green1 = "#73daca"
  let green2 = "#41a6b5"
  let magenta = "#bb9af7"
  let magenta = "#bb9af8"
  let magenta2 = "#ff007c"
  let orange = "#ff9e64"
  let purple = "#9d7cd8"
  let red = "#f7768e"
  let red1 = "#db4b4b"
  let teal = "#1abc9c"
  let terminal_black = "#414868"
  let yellow = "#e0af68"

  let arg = $blue1
  let block = $fg_dark
  let call = $blue5
  let constant = $orange
  let date = $green1
  let error = $red1
  let function = $blue
  let hint = $comment
  let normal = $fg
  let pattern = $blue6
  let record = $blue1
  let selected = $blue0
  let selected = $orange
  let string = $green

  let night = {
    # color for nushell primitives
    binary: $constant
    block: $block
    bool: $constant
    cellpath: $pattern
    date: $date
    duration: $constant
    empty: $normal
    filesize: $constant
    float: $constant
    header: { fg: $cyan, attr: b }
    hints: $hint
    int: $constant

    # no fg, no bg, attr non effectively turns this off
    leading_trailing_space_bg: { attr: n }
    list: $record
    nothing: $normal
    range: $pattern
    record: $record
    row_index: $constant
    separator: $hint
    string: $string

    # shapes are used to change the CLI syntax highlighting
    shape_binary: { fg: $constant, attr: b }
    shape_block: { fg: $block, attr: b }
    shape_bool: { fg: $constant, attr: b }
    shape_custom: $constant
    shape_datetime: $date
    shape_external: $call
    shape_externalarg: $arg
    shape_filepath: $pattern
    shape_flag: { fg: $arg, attr: b }
    shape_float: { fg: $constant, attr: b }
    shape_garbage: { fg: $error, attr: b }
    shape_globpattern: $pattern
    shape_int: { fg: $constant, attr: b }
    shape_internalcall: { fg: $call, attr: b }
    shape_list: $record
    shape_literal: { fg: $constant, attr: b }
    shape_nothing: $normal
    shape_operator: $call
    shape_range: $pattern
    shape_record: $record
    shape_signature: { fg: $block, attr: b }
    shape_string: $string
    shape_string_interpolation: $string
    shape_table: { fg: $function, attr: b }
    shape_variable: $magenta
  }

  $env.config.color_config = $night
  $env.config.menus = [
      # Configuration for default nushell menus
      # Note the lack of source parameter
      {
        name: completion_menu
        only_buffer_difference: false
        marker: "󰍻 "
        type: {
            layout: columnar
            columns: 4
            col_width: 20
            col_padding: 2
        }
        style: {
            text: $function
            selected_text: $selected
            description_text: $yellow
        }
      }
      {
        name: history_menu
        only_buffer_difference: true
        marker: " "
        type: {
          layout: list
          page_size: 10
        }
        style: {
          text: $function
          selected_text: $selected
          description_text: $yellow
        }
      }
      {
        name: help_menu
        only_buffer_difference: true
        marker: "󰋖 "
        type: {
            layout: description
            columns: 4
            col_width: 20
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: $function
            selected_text: $selected
            description_text: $yellow
        }
      }
      # Example of extra menus created using a nushell source
      # Use the source field to create a list of records that populates
      # the menu
      {
        name: commands_menu
        only_buffer_difference: false
        marker: " "
        type: {
            layout: columnar
            columns: 4
            col_width: 20
            col_padding: 2
        }
        style: {
            text: $function
            selected_text: $selected
            description_text: $yellow
        }
        source: { |buffer, position|
            $nu.scope.commands
            | where command =~ $buffer
            | each { |it| {value: $it.command description: $it.usage} }
        }
      }
      {
        name: variable_menu
        only_buffer_difference: true
        marker: "󰫧 "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: $function
            selected_text: $selected
            description_text: $yellow
        }
        source: { |name, position|
            scope variables
            | where name =~ $name
            | sort-by name
            | each { |it| { value: $it.name description: $it.value } }
        }
      }
      {
        name: commands_with_description
        only_buffer_difference: true
        marker: " "
        type: {
            layout: description
            columns: 4
            col_width: 20
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: $function
            selected_text: $selected
            description_text: $yellow
        }
        source: { |command, position|
            scope commands
            | where command =~ $command
            | each { |it| {value: $it.command description: $it.usage} }
        }
      }
    ]
}
