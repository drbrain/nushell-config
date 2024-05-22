module search {
  # Search
  export def main [
    query: string  # Search query
    ...paths: path # Paths to search
  ] {
    run-external "rg" "--json" $query ...$paths
    | each {|record| $record | from json }
    | where type == "match"
    | get data
    | upsert path {|r| $r.path.text | path relative-to $env.PWD }
    | upsert lines {|r| $r.lines.text | str trim --right }
    | upsert start {|r| $r.submatches.start.0 }
    | upsert end {|r| $r.submatches.end.0 }
    | reject absolute_offset submatches
    | rename name match line start end
  }
}

use search *
