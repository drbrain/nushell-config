# ripgrep (rg)

def color [] {
  [
    "always",
    "ansi",
    "auto",
    "never",
  ]
}

def sort_by [] {
  [
    "accessed",
    "created",
    "modified",
    "none",
    "path",
  ]
}

# Recursively search the current directory for a regex pattern
#
# By default ripgrep respects gitignore rules and automatically skips hidden
# files, hidden directories, and binary files
export extern main [
  pattern: string # search pattern
  ...files: path # search path
  --after-context(-A): number # Show NUM lines after each match.
  --auto-hybrid-regex # Dynamically use PCRE2 if necessary.
  --before-context(-B): number # Show NUM lines before each match.
  --binary # Search binary files.
  --block-buffered # Force block buffering.
  --byte-offset(-b) # Print the 0-based byte offset for each matching line.
  --case-sensitive(-s) # Search case sensitively (default).
  --color: string@color # Controls when to use color.' -r -f -a "never auto always ansi"
  --colors: string # Configure color settings and styles.
  --column # Show column numbers.
  --context(-C): number # Show NUM lines before and after each match.
  --context-separator: string # Set the context separator string.
  --count(-c) # Only show the count of matching lines for each file.
  --count-matches # Only show the count of individual matches for each file.
  --crlf # Support CRLF line terminators (useful on Windows).
  --debug # Show debug messages.
  --dfa-size-limit: string # The upper size limit of the regex DFA.
  --encoding(-E): string # Specify the text encoding of files to search.
  --engine: string # Specify which regexp engine to use.' -r -f -a "default pcre2 auto"
  --field-context-separator: string # Set the field context separator.
  --field-match-separator: string # Set the match separator.
  --file(-f): path # Search for patterns from the given file.
  --files # Print each file that would be searched.
  --files-with-matches(-l) # Print the paths with at least one match.
  --files-without-match # Print the paths that contain zero matches.
  --fixed-strings(-F) # Treat the pattern as a literal string.
  --follow(-L) # Follow symbolic links.
  --glob(-g): glob # Include or exclude files.
  --glob-case-insensitive # Process all glob patterns case insensitively.
  --heading # Print matches grouped by each file.
  --help(-h) # Prints help information. Use --help for more details.
  --hidden(-.) # Search hidden files and directories.
  --iglob: glob # Include or exclude files case insensitively.
  --ignore
  --ignore-case(-i) # Case insensitive search.
  --ignore-dot
  --ignore-exclude
  --ignore-file: path # Specify additional ignore files.
  --ignore-file-case-insensitive # Process ignore files case insensitively.
  --ignore-files
  --ignore-global
  --ignore-messages
  --ignore-parent
  --ignore-vcs
  --include-zero # Include files with zero matches in summary
  --invert-match(-v) # Invert matching.
  --json # Show search results in a JSON Lines format.
  --line-buffered # Force line buffering.
  --line-number(-n) # Show line numbers.
  --line-regexp(-x) # Only show matches surrounded by line boundaries.
  --max-columns(-M): number # Don\'t print lines longer than this limit.
  --max-columns-preview # Print a preview for lines exceeding the limit.
  --max-count(-m): number # Limit the number of matches.
  --max-depth: number # Descend at most NUM directories.
  --max-filesize: string # Ignore files larger than NUM in size.
  --messages
  --mmap # Search using memory maps when possible.
  --multiline(-U) # Enable matching across multiple lines.
  --multiline-dotall # Make \'.\' match new lines when multiline is enabled.
  --no-auto-hybrid-regex
  --no-binary
  --no-block-buffered
  --no-column
  --no-config # Never read configuration files.
  --no-context-separator
  --no-crlf
  --no-encoding
  --no-filename(-I) # Never print the file path with the matched lines.
  --no-fixed-strings
  --no-follow
  --no-glob-case-insensitive
  --no-heading # Don\'t group matches by each file.
  --no-hidden
  --no-ignore # Don\'t respect ignore files.
  --no-ignore-dot # Don\'t respect .ignore files.
  --no-ignore-exclude # Don\'t respect local exclusion files.
  --no-ignore-file-case-insensitive
  --no-ignore-files # Don\'t respect --ignore-file arguments.
  --no-ignore-global # Don\'t respect global ignore files.
  --no-ignore-messages # Suppress gitignore parse error messages.
  --no-ignore-parent # Don\'t respect ignore files in parent directories.
  --no-ignore-vcs # Don\'t respect VCS ignore files.
  --no-json
  --no-line-buffered
  --no-line-number(-N) # Suppress line numbers.
  --no-max-columns-preview
  --no-messages # Suppress some error messages.
  --no-mmap # Never use memory maps.
  --no-multiline
  --no-multiline-dotall
  --no-one-file-system
  --no-pcre2
  --no-pcre2-unicode # Disable Unicode mode for PCRE2 matching.
  --no-pre
  --no-require-git # Do not require a git repository to use gitignores.
  --no-search-zip
  --no-sort-files
  --no-stats
  --no-text
  --no-trim
  --no-unicode # Disable Unicode mode.
  --null(-0) # Print a NUL byte after file paths.
  --null-data # Use NUL as a line terminator instead of \\n.
  --one-file-system # Do not descend into directories on other file systems.
  --only-matching(-o) # Print only matched parts of a line.
  --passthru # Print both matching and non-matching lines.
  --path-separator: string # Set the path separator.
  --pcre2(-P) # Enable PCRE2 matching.
  --pcre2-unicode
  --pcre2-version # Print the version of PCRE2 that ripgrep uses.
  --pre: string # search outputs of COMMAND FILE for each FILE
  --pre-glob: glob # Include or exclude files from a preprocessing command.
  --pretty(-p) # Alias for --color always --heading --line-number.
  --quiet(-q) # Do not print anything to stdout.
  --regex-size-limit: string # The upper size limit of the compiled regex.
  --regexp(-e): string # A pattern to search for.
  --replace(-r): string # Replace matches with the given text.
  --require-git
  --search-zip(-z) # Search in compressed files.
  --smart-case(-S) # Smart case search.
  --sort: string@sort_by # Sort results in ascending order. Implies --threads=1.' -r -f -a "path modified accessed created none"
  --sort-files # DEPRECATED
  --sortr: string@sort_by # Sort results in descending order. Implies --threads=1.' -r -f -a "path modified accessed created none"
  --stats # Print statistics about this ripgrep search.
  --text(-a) # Search binary files as if they were text.
  --threads(-j): number # The approximate number of threads to use.
  --trace
  --trim # Trim prefixed whitespace from matches.
  --type(-t): string # Only search files matching TYPE.
  --type-add: string # Add a new glob for a file type.
  --type-clear: string # Clear globs for a file type.
  --type-list # Show all supported file types.
  --type-not(-T): string # Do not search files matching TYPE.
  --unicode
  --unrestricted(-u) # Reduce the level of "smart" searching.
  --version(-V) # Prints version information
  --vimgrep # Show results in vim compatible format.
  --with-filename(-H) # Print the file path with the matched lines.
  --word-regexp(-w) # Only show matches surrounded by word boundaries.
]
