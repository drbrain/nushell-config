module completions_mdfind {
  export extern "mdfind" [
    -attr: string  # Fetches the value of the specified attribute
    -count         # Query only reports matching items count
    -onlyin: glob  # Search only within given directory
    -live          # Query should stay active
    -name: string  # Search on file name only
    -reprint       # Reprint results on live update
    -s: string     # Show contents of smart folder <name>
    -0             # Use NUL as a path separator, for use with xargs -0.
    query?: string
  ]
}

use completions_mdfind *
