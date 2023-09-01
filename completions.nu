source "docker_wrapper.nu"

source "completions/ag.nu"
source "completions/cargo.nu"
source "completions/docker.nu"
source "completions/ssh.nu"
source "completions/vimr.nu"

use completion git *
use completion tmux *

# https://github.com/nushell/nushell/issues/5959
# source "completions/mdfind.nu"
