use wrapper.nu *

export def update_environment [] {
  if (has_session) {
    environment
    | into record
    | load-env
  }
}
