extends Node

signal got_main_camera()

var main_camera:Camera3D
var active_music_player:AudioStreamPlayer3D
var active_playback:AudioStream
var stream_position:float

func play_sound(_bus : StringName, _sound : AudioStream, ..._args : Array) -> void:
	return

func play_sound_main_camera(sound:AudioStreamMP3,bus):
	get_camera()
	var new_audio_player:AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	new_audio_player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_DISABLED
	main_camera.add_child(new_audio_player)
	new_audio_player.stream = sound
	new_audio_player.bus = bus
	new_audio_player.pitch_scale = randf_range(new_audio_player.pitch_scale-0.5,new_audio_player.pitch_scale)
	new_audio_player.play(0.0)
	
	
func play_music_main_camera():
	get_camera()
	await got_main_camera
	var new_audio_player:AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	new_audio_player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_DISABLED
	main_camera.add_child(new_audio_player)
	active_music_player = new_audio_player
	new_audio_player.bus =&"Music"
	if active_playback:
		new_audio_player.stream = active_playback
		new_audio_player.play(stream_position)
	

func get_camera():
	while (main_camera == null):
		main_camera = get_tree().get_first_node_in_group("MainCamera")
		await get_tree().process_frame
	if main_camera.tree_exiting.is_connected(main_camera_changing) == false:
		main_camera.tree_exiting.connect(main_camera_changing)
	got_main_camera.emit()

func main_camera_changing():
	active_playback = active_music_player.stream
	stream_position = active_music_player.get_playback_position()
	await get_tree().process_frame
	play_music_main_camera()
