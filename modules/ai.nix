{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {
    config = config.nixpkgs.config;
  };
in
{
  services.ollama = {
    enable = true;
    package = unstable.ollama;
    acceleration = false; # Use CPU inference
    host = "0.0.0.0";
    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "-1";
    };
  };

  # Open the firewall for Ollama
  networking.firewall.allowedTCPPorts = [ 11434 ];
}
