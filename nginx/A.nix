{particularisation_config}:
{
  enableACME = true;
  addSSL = true;
  locations."/" = {
    proxyPass = "http://127.0.0.1:8096";
    proxyWebsockets = true;
  };
}
