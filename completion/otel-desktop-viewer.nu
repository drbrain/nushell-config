export extern main [
  --browers-port: int # Port for browser UI
  --db: path          # Database path.  Data will not be persisted when omitted
  --grpc: int         # OTLP GRPC port
  --host: string      # Endpoint bind host
  --http: int         # OTLP HTTP port
  --open-browser      # Open the browser on launch (automatic)
  --version(-v)       # Show version
]
