{lib, ...}: with lib; {
  time.timeZone = mkDefault "America/New_York";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
}
