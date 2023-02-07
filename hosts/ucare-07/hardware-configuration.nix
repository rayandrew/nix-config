# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    # 500GB SSD
    "/" = {
      device = "/dev/disk/by-uuid/7e1e2919-a081-493f-a653-542eb7892bc0";
      fsType = "ext4";
    };
    # 1TB SSD
    "/mnt/ssd-1" = {
      device = "/dev/disk/by-uuid/8601910d-9fe8-4b5f-9d3a-5e4c949bf71c";
      fsType = "ext4";
    };
    # 1TB HDD
    "/mnt/hdd-1" = {
      device = "/dev/disk/by-uuid/25583dce-823c-4e45-a793-273b93651e4a";
      fsType = "ext4";
    };
    # 120GB HDD
    "/mnt/hdd-2" = {
      device = "/dev/disk/by-uuid/6fdb11fc-1584-4e5d-ae9a-db4766987935";
      fsType = "ext4";
    };
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/032dc53d-4a0c-4431-a2ca-e94301e2f84b"; }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}