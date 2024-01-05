{ ... }: {
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
    supportedFilesystems = [ "btrfs" ];
  };

  time.timeZone = "Europe/Paris";
  # Fix for my Broadcom card when using phone tethering
  networking.networkmanager.wifi.scanRandMacAddress = false;
}
