# Fast, flexible remote copy and synchronization
#
# Rsync copies files either to or from a remote host, or locally on the current host (it does not
# support copying files between two remote hosts).  The rsync remote-update protocol allows rsync
# to transfer just the differences between two sets of files across the network connection, using
# an efficient checksum-search algorithm.
#
# There are two different ways for rsync to contact a remote system: using a remote-shell program
# as the transport (such as ssh or rsh) or contacting an rsync daemon directly via TCP.  The
# remote-shell transport is used whenever the source or destination path contains a single colon
# (:) separator after a host specification.  Contacting an rsync daemon directly happens when the
# source or destination path contains a double colon (::) separator after a host specification, OR
# when an rsync:// URL is specified
export extern main [
  source: string            # source files
  ...dest: string           # additional sources and optional destination
  --8-bit-output(-8)        # leave high-bit chars unescaped in output
  --address: string         # bind address for outgoing socket to daemon
  --append                  # append data onto shorter files
  --archive(-a)             # archive mode; same as -rlptgoD (no -H)
  --backup(-b)              # make backups (see --suffix & --backup-dir)
  --backup-dir: string      # make backups into hierarchy based in DIR
  --block-size(-B): number  # force a fixed checksum block-size
  --blocking-io             # use blocking I/O for the remote shell
  --bwlimit: number         # limit I/O bandwidth; KBytes per second
  --cache                   # disable fcntl(F_NOCACHE)
  --checksum(-c)            # skip based on checksum, not mod-time & size
  --chmod: string           # affect file and/or directory permissions
  --compare-dest: path      # also compare destination files relative to DIR
  --compress(-z)            # compress file data during the transfer
  --compress-level: number  # explicitly set compression level
  --copy-dest: string       # ... and include copies of unchanged files
  --copy-dirlinks(-k)       # transform symlink to a dir into referent dir
  --copy-links(-L)          # transform symlink into referent file/dir
  --copy-unsafe-links       # only "unsafe" symlinks are transformed
  --cvs-exclude(-C)         # auto-ignore files the same way CVS does
  --daemon                  # run rsync as an rsync daemon
  --del                     # an alias for --delete-during
  --delay-updates           # put all updated files into place at transfer's end
  --delete                  # delete extraneous files from destination dirs
  --delete-after            # receiver deletes after transfer, not before
  --delete-before           # receiver deletes before transfer (default)
  --delete-during           # receiver deletes during transfer, not before
  --delete-excluded         # also delete excluded files from destination dirs
  --devices                 # preserve device files (super-user only)
  --dirs(-d)                # transfer directories without recursing
  --dry-run(-n)             # show what would have been transferred
  --exclude-from: path      # read exclude patterns from FILE
  --exclude: string         # exclude files matching PATTERN
  --executability           # preserve the file's executability
  --existing                # skip creating new files on receiver
  --extended-attributes(-E) # copy extended attributes
  --files-from: path        # read list of source-file names from FILE
  --filter(-f): string      # add a file-filtering RULE
  --force                   # force deletion of directories even if not empty
  --from0(-0)               # all *-from/filter files are delimited by 0s
  --fuzzy(-y)               # find similar file for basis if no dest file
  --group(-g)               # preserve group
  --hard-links(-H)          # preserve hard links
  --help(-h)                # show this help (-h works with no other options)
  --human-readable(-h)      # output numbers in a human-readable format
  --ignore-errors           # delete even if there are I/O errors
  --ignore-existing         # skip updating files that already exist on receiver
  --ignore-times(-I)        # don't skip files that match in size and mod-time
  --include-from: path      # read include patterns from FILE
  --include: string         # don't exclude files matching PATTERN
  --inplace                 # update destination files in-place (SEE MAN PAGE)
  --ipv4(-4)                # prefer IPv4
  --ipv6(-6)                # prefer IPv6
  --itemize-changes(-i)     # output a change-summary for all updates
  --keep-dirlinks(-K)       # treat symlinked dir on receiver as dir
  --link-dest: path         # hardlink to files in DIR when unchanged
  --links(-l)               # copy symlinks as symlinks
  --list-only               # list the files instead of copying them
  --log-file-format: string # log updates using the specified FMT
  --log-file: string        # log what we're doing to the specified FILE
  --max-delete: number      # don't delete more than NUM files
  --max-size: number        # don't transfer any file larger than SIZE
  --min-size: number        # don't transfer any file smaller than SIZE
  --modify-window: number   # compare mod-times with reduced accuracy
  --no-OPTION               # turn off an implied OPTION (e.g. --no-D)
  --no-implied-dirs         # don't send implied dirs with --relative
  --no-motd                 # suppress daemon-mode MOTD (see manpage caveat)
  --numeric-ids             # don't map uid/gid values by user/group name
  --omit-dir-times(-O)      # omit directories when preserving times
  --one-file-system(-x)     # don't cross filesystem boundaries
  --only-write-batch: path  # like --write-batch but w/o updating destination
  --out-format: string      # output updates using the specified FORMAT
  --owner(-o)               # preserve owner (super-user only)
  --partial                 # keep partially transferred files
  --partial-dir: path       # put a partially transferred file into DIR
  --password-file: path     # read password from FILE
  --perms(-p)               # preserve permissions
  --port: number            # specify double-colon alternate port number
  --progress                # show progress during transfer
  --protocol: number        # force an older protocol version to be used
  --prune-empty-dirs(-m)    # prune empty directory chains from the file-list
  --quiet(-q)               # suppress non-error messages
  --read-batch: path        # read a batched update from FILE
  --recursive(-r)           # recurse into directories
  --relative(-R)            # use relative path names
  --remove-source-files     # sender removes synchronized files (non-dirs)
  --rsh(-e): string         # specify the remote shell to use
  --rsync-path: path        # specify the rsync to run on the remote machine
  --safe-links              # ignore symlinks that point outside the source tree
  --size-only               # skip files that match in size
  --sockopts: string        # specify custom TCP options
  --sparse(-S)              # handle sparse files efficiently
  --specials                # preserve special files
  --stats                   # give some file-transfer stats
  --suffix: string          # set backup suffix (default ~ w/o --backup-dir)
  --super                   # receiver attempts super-user activities
  --temp-dir(-T): path      # create temporary files in directory DIR
  --timeout: string         # set I/O timeout in seconds
  --times(-t)               # preserve times
  --update(-u)              # skip files that are newer on the receiver
  --verbose(-v)             # increase verbosity
  --version                 # print version number
  --whole-file(-W)          # copy files whole (without rsync algorithm)
  --write-batch: path       # write a batched update to FILE
  -D                        # same as --devices --specials
  -F                        # same as --filter='dir-merge /.rsync-filter'
  -P                        # same as --partial --progress
]

# Run rsync as a daemon
export extern "rsync --daemon" [
  --address: string         # bind to the specified address
  --bwlimit: number         # limit I/O bandwidth; KBytes per second
  --config: path            # specify alternate rsyncd.conf file
  --help                    # show this help screen
  --ipv4(-6)                # prefer IPv4
  --ipv6(-6)                # prefer IPv6
  --log-file-format: string # override the "log format" setting
  --log-file: path          # override the "log file" setting
  --no-detach               # do not detach from the parent
  --port: number            # listen on alternate port number
  --sockopts: string        # specify custom TCP options
  --verbose(-v)             # increase verbosity
]
