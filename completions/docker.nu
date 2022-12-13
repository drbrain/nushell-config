use docker_wrapper

module completions_docker {
  export def "docker image ls" (--ignored) {
    docker_wrapper images
  }

}

use completions_docker *
