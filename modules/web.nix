{ config, pkgs, ... }:

let
  particularisation_config = import ../particularisation_config.nix;
  nginx_config = (import ../nginx.nix) { inherit particularisation_config; };
in
{
  # Nginx
  services.nginx = nginx_config;

  # ACME/Let's Encrypt
  security.acme = {
    acceptTerms = true;
    defaults.email = "fidgetbeeby@gmail.com";
    # certs."turn.${particularisation_config.domain_name}" = {
    #   postRun = "systemctl restart coturn";
    #   group = "turnserver";
    # };
  };
}

