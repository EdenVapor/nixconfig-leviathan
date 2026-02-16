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

  systemd.services.ollama-model-loader = {
    description = "Load Ollama model minimax-m2.5";
    after = [ "ollama.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "ollama";
      Group = "ollama";
      ExecStart = "${unstable.ollama}/bin/ollama run minimax-m2.5 ''";
      Restart = "on-failure";
      RestartSec = "5s";
      Environment = [
        "OLLAMA_HOST=http://127.0.0.1:11434"
        "HOME=%h" # Explicitly set HOME using systemd specifier, just in case
      ];
    };
  };
}
