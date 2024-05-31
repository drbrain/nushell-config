# neovide

def frame [] {
  [
    [value description];
    ["full" "All decorations (default)"]
    ["none" "No decorations at all"]
    ["transparent" "Trasparent decorations including a transparent bar"]
    ["buttonless" "All decorations but without quit minimize or fullscreen buttons"]
  ]
}

# NeoVim GUI
export extern main [
  ...files: path                  # Files to edit
  --fork                          # Spawn a child process and leak it
  --frame: string@frame           # Which window decorations to use
  --grid: string                  # The initial grid size of the window
  --log                           # Enables the log file for debugging purposes
  --maximized                     # Maximize the window on startup
  --neovim-bin: path              # Which NeoVim binary to invoke headlessly
  --no-fork                       # Be "blocking" and let the shell persist as parent process
  --no-idle                       # Render every frame
  --no-multigrid                  # Disable the Multigrid extension
  --no-srgb                       # Do not request sRGB when initializing the window
  --no-tabs                       # Disable opening multiple files supplied in tabs
  --no-vsync                      # Do not try to request VSync on the window
  --serer: string                 # Connect to a named pipe or socket
  --size: int                     # The size of the window in pixels
  --srgb                          # Request sRGB when initailizing the window
  --tabs                          # Enable opening multiple files in tabs
  --title-hidden                  # Setts title hidden for the window
  --version(-V)                   # Print version
  --vsync                         # Request VSync on the window
  --wayland-app-id: string        # The app ID to show to the compositor
  --wsl                           # Run NeoVim in WSL rather than the host
  --x11-wm-class-instance: string # The instant part of the X11 WM_CLASSS property
  --x11-wm-class: string          # The class part of the X11 WM_CLASS property
]
