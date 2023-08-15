# this file is both a valid
# - overlay which can be loaded with `overlay use starship.nu`
# - module which can be used with `use starship.nu`
# - script which can be used with `source starship.nu`

# Starship prompt with iTerm2 integration
#
# Based on https://iterm2.com/shell_integration/zsh
export-env {
  load-env {
    STARSHIP_SHELL: "nu"
    STARSHIP_SESSION_KEY: (random chars -l 16)
    PROMPT_MULTILINE_INDICATOR: (
      ^/opt/homebrew/bin/starship prompt --continuation
    )

    # Does not play well with default character module.
    # TODO: Also Use starship vi mode indicators?
    PROMPT_INDICATOR: ""

    PROMPT_COMMAND: {||
      let pre_prompt = ""

      # Report last exit code
      let pre_prompt = $pre_prompt + $"\e]133;D;($env.LAST_EXIT_CODE)\a"

      # Mark start of prompt
      let pre_prompt = $pre_prompt + "\e]133;A;\a"

      # Report Current directory
      let pre_prompt = $pre_prompt + $"\e]1337;CurrentDir=($env.PWD)\a"

      let prompt = (
        ^/opt/homebrew/bin/starship prompt
          --cmd-duration $env.CMD_DURATION_MS
          $"--status=($env.LAST_EXIT_CODE)"
          --terminal-width (term size).columns
      )

      # Mark end of prompt
      let post_prompt = "\e]133;B;\a"

      # Mark start of output
      let output_cr = if $env.TERM_PROGRAM == "iTerm.app" {
        "\r"
      } else {
        ""
      }

      let post_prompt = $post_prompt + $"\e]133;C;($output_cr)\a"

      # Mark shell integration
      let post_prompt = $post_prompt + "\e]1337;ShellIntegrationVersion=16;shell=nu\a"

      $pre_prompt + $prompt + $post_prompt
    }

    config: ($env.config? | default {} | merge {
      render_right_prompt_on_last_line: true
    })

    PROMPT_COMMAND_RIGHT: {||
      (
        ^/opt/homebrew/bin/starship prompt
          --right
          --cmd-duration $env.CMD_DURATION_MS
          $"--status=($env.LAST_EXIT_CODE)"
          --terminal-width (term size).columns
      )
    }
  }
}
