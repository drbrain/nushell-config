# Installation

1. Make a fork of this repository

   The nushell APIs are unstable and break things often.  I don't keep up with
   the latest nushell release so sometimes things will be broken because they
   are out-of-date.  Or I may update to a new version that won't work for you.
1. Clone this repository to a directory like `~/.config/nu`

   **NOT `~/.config/nushell`**.  *This does not replace `config.nu` nor
   `env.nu` nor any of the other default files*
1. Run `git submodule update --init --recursive` to load
   [nupm](https://github.com/nushell/nupm/tree/main)
1. Edit your `env.nu` to add `~/.config/nu` to your `$env.NU_LIB_DIRS`

   Your `env.nu` lives next to `config.nu` which you can edit with `config nu`,
   then use your editor tools to switch to the other file.  Also,
   `$env.NU_LIB_DIRS | first | path dirname | path join "env.nu"` should be the
   path to your `env.nu`
1. Edit your `config.nu` and add `source init.nu` to the bottom

   This loads the `init.nu` from this repository.
1. Start a new `nu` instance

   A command like `help ssh` should show nushell-format help for the `ssh`
   command.  This indicates everything loaded correctly.

# Support

I don't update to the latest nushell consistently so things may be broken or
out of date.

# Commands

For commands I use frequently I've created enhanced completions and wrappers
that provide tables, lists, and records as output instead of the plain-text
forms.  Not all commands are fully-wrapped.

* `ag` [The Silver Searcher](https://github.com/ggreer/the_silver_searcher)
* `atuin` [magical shell history](https://atuin.sh)
* `brew` [Homebrew package manager](https://brew.sh)
* `cargo` [Rust package manager](https://doc.rust-lang.org/cargo/)
* `docker` [Docker CLI](https://docs.docker.com/engine/reference/commandline/cli/)
  (minimal)
* `git` [distributed version control system](https://git-scm.com) has its own
  repository [nu-git](https://github.com/drbrain/nu-git)
* `rg` [ripgrep](https://github.com/BurntSushi/ripgrep)
* `rsync` [incremental file transfer](https://rsync.samba.org)
* `rustup` [Rust installer](https://rustup.rs)
* `ssh` [OpenSSH](https://www.openssh.com)
* `tmux` [terminal multiplexer](https://github.com/tmux/tmux/wiki)

# Wrappers

Supporting the above commands are some wrappers that are not loaded as shell
commands by default.  They're designed for supporting the commands listed above
so they are neither named nor namespaced in a friendly way.

One you have `$env.NU_LIB_DIRS` set up you can load the wrappers from scripts
(or into your shell):

```nushell
# Load all `export`ed items from wrapper/ssh.nu
use wrapper ssh *

# Load only the listed items from wrapper/tmux.nu
use wrapper tmux [environment update-environment]

# Load only list_dependencies from wrapper/cargo.nu
use wrapper cargo list_dependencies
```

For more information see the [nushell module
documentation](https://www.nushell.sh/book/modules.html#modules)
