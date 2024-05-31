# GNU Privacy Guard
export extern main []

# List GPG keys
export def "list-keys" [
  ...names: string # Names of keys to list
] {
  run-external "gpg" "--with-colons" "--list-keys" ...$names
  | decode # GPG says --with-colons is UTF-8 only.  That is a lie
  | lines
  | parse "{type}:{validity}:{length}:{public_key_algorithm}:{key_id}:{created}:{expires}:{hash}:{trust}:{user_id}:{signature_class}:{capabilities}:{issuer_fingerprint}:{flag}:{serial_number}:{hash_algorithm}:{curve_name}:{compliance_flags}:{updated}:{origin}:{comment}"
  | upsert type {|r| $r.type | expand_type }
  | upsert validity {|r| $r.validity | expand_validity }
  | upsert length {|r|
    if ($r.length | is-empty) {
      null
    } else {
      $r.length? | into int
    }
  }
  | upsert public_key_algorithm {|r| $r.public_key_algorithm | expand_pkey_algorithm }
  | upsert created {|r|
    if ($r.created | is-empty) {
      null
    } else {
      $r.created | into datetime --format "%s"
    }
  }
  | upsert expires {|r|
    if ($r.expires | is-empty) {
      null
    } else {
      $r.expires | into datetime --format "%s"
    }
  }
  | upsert trust {|r| $r.trust | expand_trust }
  | upsert updated {|r|
    if ($r.updated | is-empty) {
      null
    } else {
      $r.updated | into datetime --format "%s"
    }
  }
}

# https://www.iana.org/assignments/openpgp/openpgp.xml#openpgp-public-key-algorithms
def expand_pkey_algorithm [] {
  match $in {
    1 => "RSA"
    2 => "RSA encrypt-only"
    3 => "RSA sign-only"
    16 => "Elgamal encrypt-only"
    17 => "DSA"
    18 => "ECDH"
    19 => "ECDSA"
    22 => "EdDSA"
    25 => "X25519"
    26 => "X448"
    27 => "Ed25519"
    28 => "Ed448"
    "" => null
    _ => { $in | into int }
  }
}

def expand_trust [] {
  match $in {
    "m" => "marginal"
    "u" => "ultimate"
    "" => null
    _ => $in
  }
}

def expand_type [] {
  match $in {
    "cfg" => "configuration data"
    "crs" => "X.509 certificate and private key available"
    "crt" => "X.509 certificate"
    "fp2" => "SHA-256 fingerprint"
    "fpr" => "fingerprint"
    "grp" => "keygrip"
    "pkd" => "public key data"
    "pub" => "public key"
    "rev" => "revocation signature"
    "rvk" => "revocation key"
    "rvs" => "revocation signature"
    "sec" => "secret key"
    "sig" => "signature"
    "spk" => "signature subpacket"
    "ssb" => "secret subkey"
    "sub" => "subkey"
    "tfs" => "TOFU statistics"
    "tru" => "trust database information"
    "uat" => "user attribute"
    "uid" => "user id"
    "" => null
    _ => $in
  }
}

def expand_validity [] {
  match $in {
    "!" => "good"
    "%" => "other error"
    "-" => "bad"
    "-" => "unknown"
    "?" => "unusable"
    "d" => "disabled"
    "e" => "expired"
    "f" => "fully"
    "i" => "invalid"
    "m" => "marginal"
    "n" => "not valid"
    "o" => "unknown"
    "q" => "undefined"
    "r" => "revoked"
    "s" => "special"
    "u" => "ultimate"
    "w" => "well known"
    "" => null
    _ => $in
  }
}
