use wrapper.nu *

export def update-environment [] {
  if (has_session) {
    environment
    | into record
    | load-env
  }
}
