use wrapper ssh ssh_hosts
use wrapper wezterm *

def direction [] {
  [
    Down
    Left
    Next
    Prev
    Right
    Up
  ]
}

def resample_filter [] {
  [
    catmull-rom
    gaussian
    lanczos3
    nearest
    triangle
  ]
}

def resample_format [] {
  [
    input
    jpeg
    png
  ]
}

def tmux_passthrough [] {
  [
    detect
    disable
    enable
  ]
}

# Wez's terminal emulator
export extern main [
  --skip-config       # Skip loading wezterm.lua
  --config-file: path # Use this configuration file instead of the default
  --config: string    # Override specific configuration values
  --version(-V)       # Print version
]

# Interact with the experimental mux server
export extern cli [
  --no-auto-start # Don't automatically start the server
  --prefer-mux    # Prefer connecting to the background mux server
  --class: string # Should match the GUI class name
]

# Changes the active pane to the one in the specified direction
export extern "cli activate-pane-direction" [
  direction: string@direction # Direction to switch to
  --pane-id: int@panes        # The current pane
]

# Activate (focus) a pane
export extern "cli activate-pane" [
  --pane-id: int@panes # The current pane
]

# Activate (focus) a tab
export extern "cli activate-tab" [
  --tab-id: int@tabs   # The target tab by ID
  --tab-index: int     # The target tab by index
  --tab-relative: int  # The target tab by relative offset.  negative is left
  --no-wrap            # Do not wrap around with --tab-relative
  --pane-id: int@panes # The current pane
]

# Adjust the size of a pane directionally
export extern "cli adjust-pane-size" [
  direction: string@direction # Direction to resize in
  --pane-id: int@panes        # The target pane
  --amount: int               # The number of cells to resize by
]

# Determine the adjacent pane in the specified direction
export extern "cli get-pane-direction" [
  direction: string@direction # The direction to consider
  --pane-id: int@panes        # The target pane
]

# Retrieve the textual content of a pane and output it to stdout
export extern "cli get-text" [
  --pane-id: int@panes # The target pane
  --start-line: int    # Starting line number
  --end-line: int      # Ending line number
  --escapes            # Include escape sequences that color and style the text
]

# Kill a pane
export extern "cli kill-pane" [
  --pane-id: int@panes # The target pane
]

# List windows, tabs, and panes
export def "cli list-clients" [] {
  run-external "wezterm" "cli" "list-clients" "--format" "json"
  | from json
}

# List windows, tabs, and panes
export def "cli list" [] {
  run-external "wezterm" "cli" "list" "--format" "json"
  | from json
}

# Move a pane into a new tab
export extern "cli move-pane-to-new-tab" [
  --pane-id: int@panes     # The pane that should be moved
  --window-id: int@windows # The window into which the new tab will be created
  --new-window             # Create the tab in a new window
  --workspace: string      # If creating a new window, override the default workspace
]

# Start RPC proxy pipe
export extern "cli proxy" []

# Rename a workspace
export extern "cli rename-workspace" [
  new_name: string     # New workspace name
  --workspace: string  # The workspace to rename
  --pane-id: int@panes # The current pane
]

# Send text to the pane as though it were pasted
export extern "cli send-text" [
  text?: string        # Text to send.  Reads from stdin if omitted
  --pane-id: int@panes # The target pane
  --no-paste           # Send the text directly, not as a bracketed paste

]

# Change the title of a tab
export extern "cli set-tab-title" [
  title: string        # The new title for the tab
  --tab-id: int@tabs   # The target tab by ID
  --pane-id: int@panes # The current pane
]

# Change the title of a window
export extern "cli set-window-title" [
  title: string            # The new title for the window
  --window-id: int@windows # The target window
  --pane-id: int@panes     # The current pane
]

# Output an image to the terminal
export extern "imgcat" [
  image?: path                                # Image to display.  Reads from stdin if omitted
  --width: string                             # The display width
  --height: string                            # The display height
  --no-preserve-aspect-ratio                  # Do not respect the ascpet ratio
  --position: string                          # Set the cursor position before displaying the image
  --no-move-cursor                            # Do not move the cursor after displaying the image
  --hold                                      # Wait for enter to be pressed
  --tmux-passthrough: string@tmux_passthrough # How to manage passing the escape through tmux
  --max-pixels: int                           # Maximum number of pixels per image frame
  --no-resample                               # Do not resample images whose frames are larger than --max-pixels
  --resample-format: string@resample_format   # Specify the image format to use to encode resampled or resized images
  --resample-filter: string@resample_filter   # Specify the filtering technique to use when resizing or resampling images
  --resize: string                            # Pre-process the image to resize it to these dimensions
  --show-resample-timing                      # When resizing or resampling display some performance diagnostics
]

# Display information about fonts
export extern "ls-fonts" [
  --list-system # Whether to list all fonts available to the system
  --text: string # Explain which fonts are used to render the supplied text
  --codepoints: string # Explain which fonts are used to render a unicode sequence
  --rasterize-ascii # Show rasterized glyphs for text from --text or --codepoints
]

# Record a terminal session as an asciicast
export extern record [
  ...program: string    # Run the given program instead the configured shell
  --cwd: path           # Specify the working directory of the spawned program
]

# Replace an asciicast terminal session
export extern replay [
  --explain      # Explain what is being sent and received
  --explain-only # Don't replay, just show the explanation
  --cat          # Just emit raw escape sequences all at once without timing information
]

# Open a serial port
export extern "serial" [
  port: path         # Serial device name
  --baud: int        # The baud rate
  --class: string    # Override the default windowing system class
  --position: string # Override the position for the window launched by this process
]

# Spawn a command into a new window or tab
export extern "cli spawn" [
  ...program: string       # Run the given program instead the configured shell
  --cwd: path              # Specify the working directory of the spawned program
  --domain-name: string    # Spawn into this multiplexer domain
  --new-window             # Spawn into a new window instead of a tab
  --pane-id: int@panes     # The current pane
  --window-id: int@windows # The target window
  --workspace: string      # Override the default workspace
]

# Split the current pane
export extern "cli split-pane" [
  ...program: string        # Run the given program instead the configured shell
  --cwd: path               # Specify the working directory of the spawned program
  --horizontal              # Split horizontally with the new pane on the right
  --right                   # Split horizontally with the new pane on the right
  --left                    # Split horizontally with the new pane on the left
  --top                     # Split vertically with the new pane on the top
  --bottom                  # Split vertically with the new pane on the bottom
  --top-level               # Rather than splitting the active pane, split the entire window
  --cells: int              # Number of cells the new split should have
  --percent: int            # The number of cells the new split should have as a percentage of available space
  --move-pane-id: int@panes # Instead of spawning a new command, move the specified pane into the newly created split
]

# Zoom, unzoom, or toggle zoom state
export extern "cli zoom-pane" [
  --pane-id: int@panes # The target pane
  --zoom               # Zooms the pane if it wasn't already zoomed
  --unzoom             # Unzooms the pane if it was zoomed
  --toggle             # Toggle the zoom state of the pane
]

# Connect to the wezterm multiplexer
export extern connect [
  domain_name: string # Name of the multiplexer domain
  ...program: string  # Run the given program instead the configured shell
  --new-tab           # When spawning into an existing GUI instance spawn a new tab in the active window
  --class: string     # Override the default windowing system class
  --workspace: string # Override the default workspace
  --position: string  # Override the position for the initial window launched by this process
]

# Obtain TLS credentials
export extern "tlscreds" []

# Advise the terminal of the current working directory
export extern set-working-directory [
  cwd?: path                                  # The directory to set
  host?: string                               # The hostname to use in the constructed file:// URL
  --tmux-passthrough: string@tmux_passthrough # How to manage passing the escape through tmux
]

# Establish an SSH session
export extern ssh [
  ssh_target: string@ssh_hosts # The target system to SSH to
  ...program: string           # Run the given program instead the configured shell
  --ssh-option(-o): string     # Override specific SSH configuration options
  -v                           # Enable verbose SSH protocol tracing
  --class: string              # Override the default windowing system class
  --position: string           # Override the position for the initial window launched by this process
]

# Start the GUI, optionally running an alternative program
export extern start [
  ...program: string   # Run the given program instead the configured shell
  --no-auto-connect    # Do not connect to domains marked as connect_automatically in your config
  --always-new-process # Always start the GUI in this invocation. This allows waiting for the process to finish
  --new-tab            # When spawning into an existing GUI instance spawn a new tab instead of window
  --cwd: path          # Specify the working directory of the spawned program
  --class: string      # Override the default windowing system class
  --workspace: string  # Override the default workspace
  --position: string   # Override the position for the initial window launched by this process
  --domain: string     # Name of the multiplexer domain section from the config to which you'd like to connect
  --attach             # Attach to an existing program with --domain, otherwise attach and spawn the program
]
