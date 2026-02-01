extends AudioStreamPlayer

func _ready() -> void:
	GVar.signal_bus.mask_changed.connect(transition_song)
	GVar.signal_bus.player_died.connect(stop_music)

func transition_song(state:GVar.MASK):
	var playback:AudioStreamPlaybackInteractive = get_stream_playback()
	if playback:
		match state:
			GVar.MASK.MASK_ON:
				playback.switch_to_clip_by_name("Music In Game Calm")
			GVar.MASK.MASK_OFF:
				playback.switch_to_clip_by_name("Music In Game Combat")
			

func stop_music():
	var playback:AudioStreamPlaybackInteractive = get_stream_playback()
	if playback:
		playback.stop()
