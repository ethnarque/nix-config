{pkgs, ...}: {
  boot = {
    initrd.luks.devices = {
      root = {
        device = "/dev/disk/by-uuid/3fc0bbc2-d6e9-4c65-b9e4-ffa97ae039b8";
        preLVM = true;
      };
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["btrfs"];
  };

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [terminus_font];
    keyMap = "us";
  };

  time.timeZone = "Europe/Paris";
}
