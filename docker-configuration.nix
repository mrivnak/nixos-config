# NixOS Docker configuration

{ config , ... }:

{
	virtualisation.docker.enable = true;
	virtualisation.oci-containers.backend = "docker";

	virtualisation.oci-containers.containers."mc-vanilla" = {
		image = "itzg/minecraft-server";
		autoStart = false;
		environment = {
			"EULA" = "true";
			"VERSION" = "1.17.1";
			"SERVER_PORT" = "25566";
			"INIT_MEMORY" = "512M";
			"MAX_MEMORY" = "2G";
			"TYPE" = "PAPER";
			"SPAWN_PROTECTION" = "0";
			"OPS" = "QCKS1";
			"TZ" = "America/New_York";
			"MOTD" = "NeoAcid Vanilla Server, powered by PaperMC";
			"SNOOPER_ENABLED" = "false";
		};
		ports = [ "25566:25566" ];
		volumes = [ "mc-vanilla_data:/data" ];
	};
}