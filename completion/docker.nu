use wrapper docker *

def image_tags () {
  ( images
  # Needs a filter to exclude images without a tag
  | select Repository Tag
  | each { |r| $"($r.Repository):($r.Tag)" }
  | sort
  )
}

def repositories () {
  ( images
  # Needs a filter to exclude images without a tag
  | select Repository
  | sort
  )
}

export def "docker images" () {
  images
}

export def "docker image ls" (--ignored) {
  images
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
