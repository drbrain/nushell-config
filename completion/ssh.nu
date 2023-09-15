use wrapper ssh *

def known-hosts [] {
  known_hosts
}

def multiplex_commands [] {
  [
    "cancel",
    "check",
    "exit",
    "forward",
    "stop",
  ]
}

def query_features [] {
  [
    "cipher",
    "cipher-auth",
    "help",
    "mac",
    "kex",
    "key",
    "key-cert",
    "key-plain",
    "key-sig",
    "protocol-version",
    "sig",
  ]
}

# Securely connect to a remote machine
export extern main [
  -4                               # Force IPv4
  -6                               # Force IPv6
  -A                               # Forward the authentication agent
  -a                               # Do not forward the authentication agent
  -B: string                       # Bind to this interface before connecting
  -b: string                       # Use the bind address as the connection source address
  -C                               # Request compression of all data
  -c: string                       # Select a cipher specification
  -D: string                       # Local dynamic port forwarding
  -E: path                         # Append debug logs to a log file
  -e: string                       # Set the escape character
  -F: string                       # Override the config file
  -f                               # Background ssh before command execution
  -G                               # Print ssh configuration and exit
  -g                               # Allow remote hosts to connect to local forwarded ports
  -I: path                         # Specify the PKCS                                       # 11 shared library for user authentication
  -i: path                         # Select a private key identity
  -J: string                       # Connect through a jump host
  -K                               # Enable GSSAPI authentication and forwarding
  -k                               # Disable GSSAPI forwarding
  -L: string                       # Forward local connections to the remote side
  -l: string                       # Set the login name
  -M                               # Enable connection sharing
  -m: string                       # Set MAC algorithms
  -N                               # Do not execute a remote command
  -n                               # Redirects stdin from /dev/null
  -O: string@multiplex_commands    # Control connection sharing
  -o: string                       # Set an ssh option
  -p: string                       # Port to use for connection
  -Q: string@query_features        # Query for supported algorithms
  -q                               # Quiet mode
  -R: string                       # Forward remote connections to the local side
  -S: path                         # Specify the control socket location
  -s                               # Request invocation of a subsystem on the remote side
  -T                               # Disable pseudo-terminal allocation
  -t                               # Force pseudo-terminal allocation
  -V                               # Display the version number and exit
  -v                               # Verbose mode
  -W: string                       # Forward stdin and stdout to the remote side
  -w: string                       # Request tunnel device forwarding
  -X                               # Enable X11 forwarding
  -x                               # Disable X11 forwarding
  -Y                               # Enable trusted X11 forwarding
  -y                               # Send logs via syslog
  destination?: string@known-hosts # Remote host to connect to
  command?: string                 # Command to run on the remote side
  ...arguments                     # Command arguments
]

def ssh_add_fingerprints [] {
  [
    "md5",
    "sha256",
  ]
}

# Add private keys to the SSH authentication agent
export extern "ssh-add" [
  ...files: path
  -c                              # Added identities are subject to confirmation before use
  -D                              # Delete all identities from the agent
  -d                              # Remove identities from the agent
  -E: string@ssh_add_fingerprints # The key fingerprint display hash algorithm
  -e: path                        # Remove keys provided by this PKCS#11 shared library
  -K                              # Load keys from a FIDO authenticator
  -k                              # When loading or deleting keys process plain private keys only
  -L                              # List loaded public key parameters
  -l                              # List loaded key fingerprints
  -q                              # Be quiet upon success
  -S: path                        # Override library for adding FIDO authenticator-hosted keys
  -s: path                        # Add keys provided by this PKCS#11 shared library
  -T: string                      # Test if private keys matching a public key are usable
  -t: string                      # Lifetime of identities added to the agent
  -v                              # Verbose mode
  -X                              # Unlock the agent
  -x                              # Lock the agent
]

# List loaded key fingerprints
export def "ssh-add -l" () {
  (^ssh-add -l
  | lines
  | parse "{bits} {fingerprint} {identity} ({type})"
  | move identity --before bits
  | move type --before bits
  )
}
