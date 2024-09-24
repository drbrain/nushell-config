# this file is both a valid
# - overlay which can be loaded with `overlay use starship.nu`
# - module which can be used with `use starship.nu`
# - script which can be used with `source starship.nu`

def wezterm_user_var [
  name: string
  value: string
] {
  let encoded = $value | encode new-base64

  $"\e]1337;SetUserVar=($name)=($encoded)\a"
}

# Starship prompt with iTerm2 integration
#
# Based on https://iterm2.com/shell_integration/zsh
{
  STARSHIP_SHELL: "nu"
  STARSHIP_SESSION_KEY: (random chars -l 16)
  PROMPT_MULTILINE_INDICATOR: (
    ^starship prompt --continuation
  )

  # Does not play well with default character module.
  # TODO: Also Use starship vi mode indicators?
  PROMPT_INDICATOR: ""

  PROMPT_COMMAND: {||
    let aid = $nu.pid
    mut pre_prompt = ""

    # Set title
    let relative_pwd = try {
      $"~/($env.PWD | path relative-to "~")"
    } catch {
      $env.PWD
    }

    $pre_prompt += $"\e]2;($env.USER)@($env.PROMPT_HOSTNAME):($relative_pwd)\e\\"

    if ($env.TERM_PROGRAM == "WezTerm") {
      $pre_prompt += (wezterm_user_var "WEZTERM_HOST" $env.PROMPT_HOSTNAME)
      $pre_prompt += (wezterm_user_var "WEZTERM_PROG" "")
      $pre_prompt += (wezterm_user_var "WEZTERM_USER" $env.USER)
    }

    # Report last exit code
    $pre_prompt += $"\e]133;D;($env.LAST_EXIT_CODE);aid=($aid)\a"

    # Report Current directory
    if ($env.TERM_PROGRAM == "WezTerm") {
      $pre_prompt += (wezterm set-working-directory)
    } else  {
      $pre_prompt += $"\e]1337;CurrentDir=($env.PWD)\a"
    }

    # Do a fresh line
    $pre_prompt += $"\e]133;A;cl=m;aid=($aid)\a"

    # Mark start of prompt
    $pre_prompt += "\e]133;P;k=i;\a"

    let prompt = (
      ^starship prompt
        --cmd-duration $env.CMD_DURATION_MS
        $"--status=($env.LAST_EXIT_CODE)"
        --terminal-width (term size).columns
    )

    # Mark end of prompt
    let post_prompt = "\e]133;B;\a"

    # Mark start of output
    let output_cr = if ($env | get -i TERM_PROGRAM) != "iTerm.app" {
      ""
    } else {
      # assume iTerm.app
      "\r"
    }

    let post_prompt = $post_prompt + $"\e]133;C;($output_cr)\a"

    # Mark shell integration
    let post_prompt = $post_prompt + "\e]1337;ShellIntegrationVersion=16;shell=nu\a"

    $pre_prompt + $prompt + $post_prompt
  }

  PROMPT_COMMAND_RIGHT: {||
    (
      ^starship prompt
        --right
        --cmd-duration $env.CMD_DURATION_MS
        $"--status=($env.LAST_EXIT_CODE)"
        --terminal-width (term size).columns
    )
  }
} | load-env

$env.config.render_right_prompt_on_last_line = true

