{ config, pkgs, ... }:

let
  particularisation_config = import ../particularisation_config.nix;
  matrix-synapse_config = (import ../matrix-synapse.nix) { inherit particularisation_config; };
  coturn_config = (import ../coturn.nix) { inherit particularisation_config; };
in
{
  services = {
    # Mastodon
    mastodon = {
      enable = true;
      localDomain = "social.birdinter.net";
      configureNginx = true;
      smtp.fromAddress = "flock@birdinter.net";
      streamingProcesses = 19;
    };

    # Matrix Synapse
    matrix-synapse = matrix-synapse_config;
    
    # Coturn TURN server
    coturn = coturn_config;
  };
}

