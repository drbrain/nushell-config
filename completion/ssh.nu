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
