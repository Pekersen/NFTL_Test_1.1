class_name DiscordIntegration extends Node

func run():
	DiscordRPC.app_id = 1387070530942799892
	DiscordRPC.details = "Running NFTL demo"
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	DiscordRPC.refresh()
