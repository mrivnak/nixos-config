# NixOS Docker configuration

{ config , ... }:

{
	virtualisation.docker.enable = true;
	virtualisation.oci-containers.backend = "docker";

	virtualisation.oci-containers.containers = {
		"home-assistant" = {
			image = "ghcr.io/home-assistant/home-assistant:stable";
			autoStart = true;
			environment = {
				"TZ" = "America/New_York";
			};
			volumes = [
				"home-assistant_config:/config"
				"/etc/localtime:/etc/localtime:ro"
			];
			extraOptions = [
				"--network=host"
				"--privileged"
			];
		};
		"mc-vanilla" = {
			image = "itzg/minecraft-server";
			autoStart = false;
			environment = {
				"EULA" = "true";
				"VERSION" = "1.18";
				"SERVER_PORT" = "25565";
				"INIT_MEMORY" = "512M";
				"MAX_MEMORY" = "2G";
				"TYPE" = "PAPER";
				"SPAWN_PROTECTION" = "0";
				"OPS" = "QCKS1";
				"TZ" = "America/New_York";
				"MOTD" = "NeoAcid Vanilla Server, powered by PaperMC";
				"SNOOPER_ENABLED" = "false";
			};
			ports = [ "25565:25565" ];
			volumes = [ "mc-vanilla_data:/data" ];
		};
		"valheim" = {
			image = "llosche/valheim-server";
			autoStart = false;
			environment = {
				"SERVER_NAME" = "NeoAcid Valheim Server";
				"WORLD_NAME" = "Dedicated";
				"SERVER_PASS" = "pizza";
				"SERVER_PUBLIC" = "true";
				"BACKUPS" = "false";
				"VALHEIM_PLUS" = "true";
			};
			ports = [
				"2456-2457:2456-2457/udp"
				"9001:9001/tcp"
			];
			volumes = [
				"valheim_config/config"
			];
			extraOptions = [
				"--cap-add=sys_nice"
			];
		};
		"terraria" = {
			image = "beardedio/terraria:vanilla-latest";
			autoStart = false;
			environment = {
				"world" = "The_Glamorous_Niche.wld";
			};
			ports = [
				"7777:7777"
			];
			volumes = [
				"terraria_data:/config"
			];
		};
	};
}
