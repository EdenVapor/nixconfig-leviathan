{ config, pkgs, ... }:

let
  particularisation_config = import ../particularisation_config.nix;
in
{
  # Networking
  networking = {
    interfaces.eno1.ipv4.addresses = [{
      address = "192.168.1.42";
      prefixLength = 24;
    }];

    hostName = "leviathan";
    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  # Firewall
  networking.firewall = {
    allowedTCPPorts = [ 80 443 8080 32400 139 445 ];
    # allowedUDPPortRanges = [ {from = particularisation_config.turn_minimal_listening_port; to = particularisation_config.turn_maximal_listening_port;} ];
    allowedUDPPorts = [ 137 138 ];
  };
}

