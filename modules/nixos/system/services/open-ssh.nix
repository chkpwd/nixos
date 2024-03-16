{ lib, ...}: with lib; {
  services = {
    openssh = mkDefault {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
}
