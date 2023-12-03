# Show the path to a symbolic ref
export extern "git symbolic-ref" [
  --no-recurse # Stop at the first symbolic ref
  --quiet(-q)  # Do not issue an error if the <name> is not a symbolic ref
  --recurse    # Follow a chain of symbolic refs (default)
  --short      # Try to shorten the value of the symbolic ref
  name: string # Symbolic ref
]

# Create a symbolic ref
export def "git symbolic ref create" [
  -m: string   # Update the reflog for <name> with this reason
  name: string # Symbolic ref to create
  ref: string  # Branch that <name> will point to
] {
  mut args = []

  if $m != null {
    $args = ( $args | append [ "-m" $m ] )
  }

  let args = ( $args | append [ $name $ref ] )

  run-external "git" "symbolic-ref" $args
}

# Delete a symbolic ref
export def "git symbolic-ref delete" [
  --quiet(-q)  # Do not issue an error if the <name> is not a symbolic ref
  name: string # Symbolic ref name to delete
] {
  mut args = [ "--delete" ]

  if $quiet {
    $args = ( $args | append "--quiet" )
  }

  let args = ( $args | append $name )

  run-external "git" "symbolic-ref" $args
}
