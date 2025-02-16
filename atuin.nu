# Source this in your ~/.config/nushell/config.nu
$env.ATUIN_SESSION = (atuin uuid)
hide-env -i ATUIN_HISTORY_ID

# Magic token to make sure we don't record commands run by keybindings
let ATUIN_KEYBINDING_TOKEN = $"# (random uuid)"

let pre_execution = {||
  if ($nu | get -i history-enabled) == false {
    return
  }
  let cmd = (commandline)
  if ($cmd | is-empty) {
    return
  }
  if not ($cmd | str starts-with $ATUIN_KEYBINDING_TOKEN) {
    $env.ATUIN_HISTORY_ID = (atuin history start -- $cmd)
  }
}

let pre_prompt = {||
  let last_exit = $env.LAST_EXIT_CODE

  if 'ATUIN_HISTORY_ID' not-in $env {
    return
  }

  with-env { ATUIN_LOG: error } {
    do {
      atuin history end $'--exit=($last_exit)' -- $env.ATUIN_HISTORY_ID
    } | complete
  }

  hide-env ATUIN_HISTORY_ID
}

def search_cmd [...flags: string] {
  let flags = $flags
    | append [--interactive]
    | each {|e| $'"($e)"'}

  [
    $ATUIN_KEYBINDING_TOKEN,
    (
      [
        'with-env { ATUIN_LOG: error, ATUIN_QUERY: (commandline) } {'
        'commandline edit (run-external atuin search'
        $flags
        ' e>| str trim)'
        '}',
      ] | flatten | str join ' '
    )
  ] | str join "\n"
}

$env.config.hooks.pre_execution ++= [ $pre_execution ]

$env.config.hooks.pre_prompt ++= [ $pre_prompt ]

$env.config.keybindings ++= [
  {
    name: atuin
    modifier: control
    keycode: char_r
    mode: [emacs, vi_normal, vi_insert]
    event: {
      send: executehostcommand
      cmd: (search_cmd)
    }
  }
]

$env.config.keybindings ++= [
  {
    name: atuin
    modifier: none
    keycode: up
    mode: [emacs, vi_normal, vi_insert]
    event: {
      until: [
        { send: menuup }
        { send: executehostcommand cmd: (search_cmd '--shell-up-key-binding') }
      ]
    }
  }
]
