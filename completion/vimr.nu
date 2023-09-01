# Open files in VimR
export extern main [
  ...files: glob # Files to open
  --help(-h)     # Show help
  --dry-run      # Print the open command
  --cwd: path    # Set the working directory
  --line: number # Go to line
  --wait         # Wait for the VimR window to close before continuing
  --nvim         # Pass arguments except --cur-env, --dry-run, and --wait to the nvim intstance in the new window
  --cur-env      # Use the current environment variables when starting VimR
  -n             # Open files in a new window
  -s             # Open files in a separate window
]
