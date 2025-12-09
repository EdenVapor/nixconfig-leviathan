{ config, pkgs, ... }:

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
  };
}

