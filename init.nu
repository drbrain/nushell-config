if not (which atuin | get path | is-empty) {
    source atuin.nu
}
source cdpath.nu
source completions.nu
source search.nu
source starship.nu
source tokyonight.nu

if ("../nu_plugin_prometheus/config.nu" | path exists) {
  source ../nu_plugin_prometheus/config.nu
}

use nupm/nupm

use ~/Work/git/nu-git git

