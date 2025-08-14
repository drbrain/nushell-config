export def list_services [] {
  if "FASTLY_API_TOKEN" in $env {
    mut services = []
    mut url = "https://api.fastly.com/service"

    loop {
      let res = http get -f -H [Fastly-Key $env.FASTLY_API_TOKEN] $url

      $services = ($services | append $res.body)

      let link = $res.headers.response | find name == "link"

      if ($link | is-empty) {
        break
      }

      let next = $link.value | parse -r '<(?<next>[^>]*?)>; rel="next"'

      if ($next | is-empty) {
        break
      }

      $url = $next.0.next

      sleep 1sec
    }

    $services
  } else {
    null
  }
}
