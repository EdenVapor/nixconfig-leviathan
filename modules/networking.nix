{ config, pkgs, ... }:

let
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
    allowedTCPPorts = [ 80 443 8080 32400 139 445 8211 27015 ];
    allowedUDPPorts = [ 137 138 8211 27015 ];
  };
}

