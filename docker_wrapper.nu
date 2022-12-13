module docker_wrapper {
  export def images [] {
    ( ^docker image ls --format '{{json .}}'
    | lines
    | par-each {|l| $l | from json }
    | upsert CreatedAt {|r| $r.CreatedAt | str replace '(.*) \w+' '$1' | into datetime }
    | upsert Size {|r| $r.Size | into filesize }
    | reject Containers CreatedSince Digest SharedSize UniqueSize VirtualSize
    | move Size --after Tag
    | move CreatedAt --after Size
    | move Repository --before Tag
    | move ID --before Repository
    )
  }
}
