extends Control

@onready var kill_count: Label = $"ColorRect/Count Titles/Kills/Kill Count"
@onready var feed_count: Label = $"ColorRect/Count Titles/Feeds/Feed Count"

func _get_stats() -> void: 
	var kills = GVar.game_manager.game_stats["Kills"]
	var feeds = GVar.game_manager.game_stats["Feeds"]

	kill_count.text = str(kills)
	feed_count.text = str(feeds)
