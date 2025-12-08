{particularisation_config}:
{
  recommendedTlsSettings = true;
  recommendedOptimisation = true;
  recommendedGzipSettings = true;
  recommendedProxySettings = true;
  enable = true;
  virtualHosts = {
    # Existing virtual hosts
    "birdintra.net" = {
      enableACME = true;
      addSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
        proxyWebsockets = true;
      };
    };
    "fidget.fans" = {
      addSSL = true;
      enableACME = true;
      root = "/var/www/fidget.fans";
    };
    "blog.birdinter.net" = {
      addSSL = true;
      enableACME = true;
      root = "/var/www/blog.birdinter.net";
    };
    "localhost" = {
      locations."~ /.well-known" = {
        priority = 9000;
        extraConfig = ''
          absolute_redirect off;
          location ~ ^/\.well-known/(?:carddav|caldav)$ {
            return 301 /remote.php/dav;
          }
          location ~ ^/\.well-known/host-meta(?:\.json)?$ {
            return 301 /public.php?service=host-meta-json;
          }
          location ~ ^/\.well-known/(?!acme-challenge|pki-validation) {
            return 301 /index.php$request_uri;
          }
          try_files $uri $uri/ =404;
        '';
      };
    };
    "bsky.birdinter.net" = {
      forceSSL = true;
      enableACME = true;
      locations."/xrpc" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
      locations."/.well-known/atproto-did" = {
        extraConfig = ''
          default_type text/plain;
          return 200 "did:web:bsky.birdinter.net";
        '';
      };
    };
    # Matrix Synapse virtual hosts (Disabled)
    # "matrix.${particularisation_config.domain_name}" = { ... };
    # TURN server virtual host (Disabled)
    # "turn.${particularisation_config.domain_name}" = { ... };
  };
}