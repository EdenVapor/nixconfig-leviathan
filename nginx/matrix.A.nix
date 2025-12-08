{particularisation_config}:
{
  enableACME = true;
  addSSL = true;
  locations."/" = {
    proxyPass = "http://127.0.0.1:8008";
    proxyWebsockets = true;
    extraConfig = ''
      proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header Host $host;
      client_max_body_size 50M;
    '';
  };
  locations."/_matrix" = {
    proxyPass = "http://127.0.0.1:8008";
    proxyWebsockets = true;
    extraConfig = ''
      proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header Host $host;
      client_max_body_size 50M;
    '';
  };
}
