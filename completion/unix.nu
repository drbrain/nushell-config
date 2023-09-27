# Set file mode bits or ACLs
export extern chmod [
  mode: string # The mode bits to set
  ...files: path # The paths to set the mode on
  -f # Do not display a diagnostic message if chmod could not modify the mode, nor modify the exit status to reflect such failures
  -H # If the -R option is specified symbolic links on the command line are followed and hence unaffected by the command.  (Symbolic links encountered during tree traversal are not followed)
  -h # If the file is a symbolic link change the mode of the link itself
  -L # If the -R option is specified all symbolic links are followed
  -P # If the -R option is specified no symbolic links are followed  (default)
  -R # Change the modes of the file hierarchies rooted in the files instead of just the files themselves
  -v # Showing filenames as the mode is modified.  If specified more than once the old and new modes of the file will also be printed
  -E # Read ACL information stdin
  -C # Return false if any of the named files have ACLs in non-canonical order
  -i # Remove the interited bit from all entries in the named files' ACLs
  -I # Remove all inherited entry from the name files' ACLs
  -N # Removes the ACL from the named files
]
