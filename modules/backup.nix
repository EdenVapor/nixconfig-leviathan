{ config, pkgs, ... }:

{
  services = {
    # BorgBackup server
    borgbackup = {
      repos.eden = {
        path = "/var/lib/borgbackup/eden";
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJiQh4EIE2PiR6ab2d8lUgX24WH82d20um/CLT9yH2df fidget@lilith"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYxapdT59ZrDWosETu1OA5d5Ca0vbcIR0TV4lYn6nNH fidget@white-whale"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFBUnJgz77B8YhFCh1Whsa0ziCRt+VPbtCCmmBLxXJD fidget@Eden"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmRvc/FaV8nNYpo9h8PHsdI7ODOXQf1g0m1BwTsUm5O fidget-borg@leviathan"
        ];
        allowSubRepos = true;
        quota = "4T";
      };
    };

    # PostgreSQL backup
    postgresqlBackup = {
      enable = true;
      databases = [ "mastodon" ];
      location = "/var/backup/postgresql";
    };
  };
}

