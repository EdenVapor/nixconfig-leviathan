{ config, pkgs, ... }:

let
  nginx_config = (import ./nginx.nix) { };
in
{
  # Nginx
  services.nginx = nginx_config;

  # ACME/Let's Encrypt
  security.acme = {
    acceptTerms = true;
    defaults.email = "fidgetbeeby@gmail.com";
  };
}

