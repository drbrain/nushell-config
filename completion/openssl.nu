export extern main []

export def "x509" [
  input: path # Certificate input

  --no-cert   # No cert output (except requested printing)
  --no-out    # No output (except requested printing)

  --text             # Print the certificate in text form
  --dateopt: string  # Datetime format used for printing. (rfc_822/iso_8601). Default is rfc_822.
  --certopt: string  # Various certificate text printing options
  --fingerprint      # Print the certificate fingerprint
  --alias            # Print certificate alias
  --serial           # Print serial number value
  --startdate        # Print the notBefore field
  --enddate          # Print the notAfter field
  --dates            # Print both notBefore and notAfter fields
  --subject          # Print subject DN
  --issuer           # Print issuer DN
  --nameopt: string  # Certificate subject/issuer name printing options
  --email            # Print email address(es)
  --hash             # Synonym for -subject_hash (for backward compat)
  --subject_hash     # Print subject hash value
  --subject_hash_old # Print old-style (MD5) subject hash value
  --issuer_hash      # Print issuer hash value
  --issuer_hash_old  # Print old-style (MD5) issuer hash value
  --ext: string      # Restrict which X.509 extensions to print and/or copy
  --ocspid           # Print OCSP hash values for the subject name and public key
  --ocsp_uri         # Print OCSP Responder URL(s)
  --purpose          # Print out certificate purposes
  --pubkey           # Print the public key in PEM format
  --modulus          # Print the RSA key modulus
] {
  mut args = []
  $args = ( $args | append [ "-in" $input ] )

  if $no_cert == true {
    $args = ( $args | append "-nocert" )
  }

  if $no_out == true {
    $args = ( $args | append "-noout" )
  }

  if $text == true {
    $args = ( $args | append "-text" )
  }
  if $dateopt == true {
    $args = ( $args | append [ "-dateopt" $dateopt ] )
  }
  if $certopt == true {
    $args = ( $args | append [ "-certopt" $certopt ] )
  }
  if $fingerprint == true {
    $args = ( $args | append "-fingerprint" )
  }
  if $alias == true {
    $args = ( $args | append "-alias" )
  }
  if $serial == true {
    $args = ( $args | append "-serial" )
  }
  if $startdate == true {
    $args = ( $args | append "-startdate" )
  }
  if $enddate == true {
    $args = ( $args | append "-enddate" )
  }
  if $dates == true {
    $args = ( $args | append "-dates" )
  }
  if $subject == true {
    $args = ( $args | append "-subject" )
  }
  if $issuer == true {
    $args = ( $args | append "-issuer" )
  }
  if $nameopt == true {
    $args = ( $args | append [ "-nameopt" $nameopt ] )
  }
  if $email == true {
    $args = ( $args | append "-email" )
  }
  if $hash == true {
    $args = ( $args | append "-hash" )
  }
  if $subject_hash == true {
    $args = ( $args | append "-subject_hash" )
  }
  if $subject_hash_old == true {
    $args = ( $args | append "-subject_hash_old" )
  }
  if $issuer_hash == true {
    $args = ( $args | append "-issuer_hash" )
  }
  if $issuer_hash_old == true {
    $args = ( $args | append "-issuer_hash_old" )
  }
  if $ext == true {
    $args = ( $args | [ append "-ext" $ext ] )
  }
  if $ocspid == true {
    $args = ( $args | append "-ocspid" )
  }
  if $ocsp_uri == true {
    $args = ( $args | append "-ocsp_uri" )
  }
  if $purpose == true {
    $args = ( $args | append "-purpose" )
  }
  if $pubkey == true {
    $args = ( $args | append "-pubkey" )
  }
  if $modulus == true {
    $args = ( $args | append "-modulus" )
  }

  let result = run-external "openssl" "x509" ...$args

  if $dates {
    let record = $result | lines | split column '=' | transpose -d -r

    {
      notBefore: ( $record.notBefore | into datetime )
      notAfter: ( $record.notAfter | into datetime )
    }
  } else {
    $result
  }
}
