{
  host_name = "leviathan"; 
  domain_name = "birdinter.net";
  email_address = "fidget@birdinter.net";
  hostPlatform = {
    system = "x86_64-linux";
    config = "x86_64-unknown-linux-gnu";  
  };
  external_ip = "192.168.1.42";
  local_ip = "192.168.1.42";
  public_ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYxapdT59ZrDWosETu1OA5d5Ca0vbcIR0TV4lYn6nNH fidget@white-whale";
  ddclient_configFile = "/etc/ddclient.conf";
  turn_cli-password = "your-turn-cli-password-here";
  turn_minimal_listening_port = 49152;
  turn_maximal_listening_port = 65535;
  matrix-synapse_turn_shared_secret_coturn = "yeYFq7+qM3Tp6zFYZ4E7rEiQDsDCTQ4OmfeOIwVqeMk=";
  matrix-synapse_max_upload_size = "50M";
  keys_paths = {
    matrix-synapse_registration_shared_secret = "/etc/nixos/secrets/matrix-synapse_registration_shared_secret";
    matrix-synapse_turn_shared_secret = "/etc/nixos/secrets/matrix-synapse_turn_shared_secret";
    matrix-synapse_macaroon_secret_key = "/etc/nixos/secrets/matrix-synapse_macaroon_secret_key";
    matrix-synapse_form_secret = "/etc/nixos/secrets/matrix-synapse_form_secret";
  };
}