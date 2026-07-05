{
  config,
  lib,
  ...
}:
# Battery/power daemon for laptops. UPower exposes battery state over D-Bus,
# which is what the shell's battery widget (and idle/critical handling) reads.
lib.mkIf (config.canvas.machine.formFactor == "laptop") {
  services.upower = {
    enable = true;
    percentageLow = 15;
    percentageCritical = 5;
    percentageAction = 3;
    criticalPowerAction = "Hibernate";
  };
}
