# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot"; # Ensure this matches your actual EFI system partition mount point
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev"; # 'nodev' is used for UEFI installations
      useOSProber = true; 
    };
  };
  boot.loader.systemd-boot.enable = false;

  # Add btrfs support
  boot.supportedFilesystems = [ "btrfs" ];
  
  # Configure mounts for your SSD with Steam games and Plex media
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/059a8a02-5b90-43e1-b85b-187c890c1f2d";
    fsType = "btrfs";
  };

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/059a8a02-5b90-43e1-b85b-187c890c1f2d";
    fsType = "btrfs";
    options = [ "subvol=games" "compress=zstd" "noatime" ];
  };

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/059a8a02-5b90-43e1-b85b-187c890c1f2d";
    fsType = "btrfs";
    options = [ "subvol=media" "compress=zstd" "noatime" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # Add user to docker group
  users.users.mmakay.extraGroups = [ "networkmanager" "wheel" "docker" ];

  # Plex firewall configuration
  networking.firewall = {
    allowedTCPPorts = [ 32400 3005 8324 32469 8080 ];
    allowedUDPPorts = [ 1900 5353 32410 32412 32413 32414 ];
  };

  # Automatic system updates
  system.autoUpgrade = {
    enable = true;
    flake = "~/nixos-config#nixos";
    flags = [ "--update-input" "nixpkgs" ];
    dates = "0/3 0:00:00";  # Run every 3 days at midnight
    randomizedDelaySec = "45min";
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";  # Run once a week
    options = "--delete-older-than 7d";  # Delete generations older than 7 days
  };

  # Optimize store to save disk space
  nix.settings.auto-optimise-store = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hu_HU.UTF-8";
    LC_IDENTIFICATION = "hu_HU.UTF-8";
    LC_MEASUREMENT = "hu_HU.UTF-8";
    LC_MONETARY = "hu_HU.UTF-8";
    LC_NAME = "hu_HU.UTF-8";
    LC_NUMERIC = "hu_HU.UTF-8";
    LC_PAPER = "hu_HU.UTF-8";
    LC_TELEPHONE = "hu_HU.UTF-8";
    LC_TIME = "hu_HU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "hu";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "hu";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.mmakay = {
    isNormalUser = true;
    description = "Makay Mátyás";
    # Note: extraGroups is now moved to the top of the file where other docker configurations are
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "mmakay";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    discord
    git
    home-manager
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  }; 

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
