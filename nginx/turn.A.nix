{
  enableACME = true;
  addSSL = true;
  locations."/" = {
    proxyPass = "http://127.0.0.1:3478";
    extraConfig = ''
      proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header Host $host;
    '';
  };
}
