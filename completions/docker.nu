use docker_wrapper

module completions_docker {
  def image_tags () {
    ( docker_wrapper images
    # Needs a filter to exclude images without a tag
    | select Repository Tag
    | each { |r| $"($r.Repository):($r.Tag)" }
    | sort
    )
  }

  def repositories () {
    ( docker_wrapper images
    # Needs a filter to exclude images without a tag
    | select Repository
    | sort
    )
  }

  export def "docker image ls" (--ignored) {
    docker_wrapper images
  }

  export extern "docker image rm" [
    ...images: string@image_tags # Images to remove
    --force(-f)                  # Force removal
    --no-prune                   # Do not delete untagged parents
  ]

  export extern "docker tag" [
    source: string@image_tags
    target: string@repositories
  ]

}

use completions_docker *
