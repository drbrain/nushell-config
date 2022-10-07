module completions_vimr {
  export extern "vimr" [
    ...files: glob
    --help(-h)
    --dry-run
    --cwd: path
    --line: number
    --wait
    --nvim
    --cur-env
    -n
    -s
  ]
}

use completions_vimr *
