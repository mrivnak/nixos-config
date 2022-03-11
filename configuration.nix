# Edit this configuration file to define whaot should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
		<home-manager/nixos>
	];

	system.autoUpgrade.enable = false;
	system.autoUpgrade.allowReboot = false;

	nix = {
		package = pkgs.nixFlakes;
		extraOptions = ''
			experimental-features = nix-command flakes
		'';
	};

	# BTRFS Configs
	boot.supportedFilesystems = [ "btrfs" ];
	services.btrfs.autoScrub = {
		enable = true;
		interval = "weekly";
	};

	# Use the systemd-boot EFI boot loader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "nixos-server"; # Define your hostname.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

	# Set your time zone.
	time.timeZone = "America/New_York";

	# The global useDHCP flag is deprecated, therefore explicitly set to false here.
	# Per-interface useDHCP will be mandatory in the future, so this generated config
	# replicates the default behaviour.
	networking.useDHCP = false;
	networking.interfaces.enp2s0.useDHCP = true;

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.michael = {
		isNormalUser = true;
		description = "Michael";
		shell = pkgs.zsh;
		extraGroups = [
			"docker"
			"wheel"
		];
	};
	users.users.mig = {
		isNormalUser = true;
		description = "Mig";
		shell = pkgs.zsh;
		extraGroups = [
			"docker"
			"wheel"
		];
	};

	# List packages installed in system profile. To search, run:
	environment.systemPackages = with pkgs; [
		curl
		file
		git
		home-manager
		neovim
		openssl
		unzip
		wget
		vim
	];
	nixpkgs.config.allowUnfree = true;

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#   enable = true;
	#   enableSSHSupport = true;
	# };

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	services.openssh = {
		enable = true;
		# passwordAuthentication = false;
		extraConfig = ''
			PrintLastLog no
		'';
	};

	virtualisation.docker = {
		enable = true;
		storageDriver = "btrfs";
  	};

	# Open ports in the firewall.
	networking.firewall.enable = true;
	networking.firewall.allowedTCPPorts = [
		8123  # home assistant
		21064 # home assistant HomeKit plugin
		5222  # home assistant Logitech Harmony
		25565 # mc-vanilla
		25566 # mc-enigmatica-6
		25567 # mx-matt-vanilla
		7777  # terraria
		7778  # terraria-tmodloader
		1883  # mosquitto
		80    # nginx
		8080  # nginx
		9443  # portainer
	];
	networking.firewall.allowedUDPPorts = [
		5353  # mDNS
		24642 # stardew
	];
	services.fail2ban.enable = true;

	services.snapper.snapshotInterval = "hourly";
	services.snapper.cleanupInterval = "1d";
	services.snapper.configs = {
		root = {
			subvolume = "/";
			extraConfig = ''
				ALLOW_GROUPS=""
				ALLOW_USERS=""
				BACKGROUND_COMPARISON=yes
				EMPTY_PRE_POST_CLEANUP=yes
				EMPTY_PRE_POST_MIN_AGE=1800
				FREE_LIMIT=0.2
				NUMBER_CLEANUP=yes
				NUMBER_LIMIT=50
				NUMBER_LIMIT_IMPORTANT=10
				NUMBER_MIN_AGE=1800
				QGROUP=""
				SPACE_LIMIT=0.5
				SYNC_ACL=no
				TIMELINE_CLEANUP=yes
				TIMELINE_CREATE=yes
				TIMELINE_LIMIT_DAILY=7
				TIMELINE_LIMIT_HOURLY=12
				TIMELINE_LIMIT_MONTHLY=6
				TIMELINE_LIMIT_WEEKLY=4
				TIMELINE_LIMIT_YEARLY=2
				TIMELINE_MIN_AGE=1800
			'';
		};
		home = {
			subvolume = "/home";
			extraConfig = ''
				ALLOW_GROUPS=""
				ALLOW_USERS=""
				BACKGROUND_COMPARISON=yes
				EMPTY_PRE_POST_CLEANUP=yes
				EMPTY_PRE_POST_MIN_AGE=1800
				FREE_LIMIT=0.2
				NUMBER_CLEANUP=yes
				NUMBER_LIMIT=50
				NUMBER_LIMIT_IMPORTANT=10
				NUMBER_MIN_AGE=1800
				QGROUP=""
				SPACE_LIMIT=0.5
				SYNC_ACL=no
				TIMELINE_CLEANUP=yes
				TIMELINE_CREATE=yes
				TIMELINE_LIMIT_DAILY=7
				TIMELINE_LIMIT_HOURLY=24
				TIMELINE_LIMIT_MONTHLY=6
				TIMELINE_LIMIT_WEEKLY=4
				TIMELINE_LIMIT_YEARLY=2
				TIMELINE_MIN_AGE=1800
			'';
		};
		docker = {
			subvolume = "/var/lib/docker";
			extraConfig = ''
				ALLOW_GROUPS=""
				ALLOW_USERS=""
				BACKGROUND_COMPARISON=yes
				EMPTY_PRE_POST_CLEANUP=yes
				EMPTY_PRE_POST_MIN_AGE=1800
				FREE_LIMIT=0.2
				NUMBER_CLEANUP=yes
				NUMBER_LIMIT=50
				NUMBER_LIMIT_IMPORTANT=10
				NUMBER_MIN_AGE=1800
				QGROUP=""
				SPACE_LIMIT=0.5
				SYNC_ACL=no
				TIMELINE_CLEANUP=yes
				TIMELINE_CREATE=yes
				TIMELINE_LIMIT_DAILY=7
				TIMELINE_LIMIT_HOURLY=24
				TIMELINE_LIMIT_MONTHLY=6
				TIMELINE_LIMIT_WEEKLY=4
				TIMELINE_LIMIT_YEARLY=2
				TIMELINE_MIN_AGE=1800
			'';
		};
	};

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "21.11"; # Did you read the comment?

}
