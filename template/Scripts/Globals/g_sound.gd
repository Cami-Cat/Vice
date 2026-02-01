extends Node

signal got_main_camera()

var main_camera:Camera3D
var active_music_player:AudioStreamPlayer
var stream_position:float

func play_sound(_bus : StringName, _sound : AudioStream, ..._args : Array) -> void:
	var new_audio_player:AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(new_audio_player)
	new_audio_player.stream = _sound
	new_audio_player.bus = _bus
	new_audio_player.pitch_scale = randf_range(new_audio_player.pitch_scale-0.2,new_audio_player.pitch_scale+0.2)
	new_audio_player.play(0.0)

func play_sound_for_time(_bus : StringName, _sound : AudioStream,time:float,start_random:bool) -> void:
	var new_audio_player:AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(new_audio_player)
	new_audio_player.stream = _sound
	new_audio_player.bus = _bus
	new_audio_player.pitch_scale = randf_range(new_audio_player.pitch_scale-0.2,new_audio_player.pitch_scale+0.2)
	var timer:Timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(kill_sound.bind(new_audio_player))
	timer.one_shot = true
	timer.start(time)
	var start_point:float = 0.0
	if start_random:
		start_point = randf_range(0.0,_sound.get_length())
	new_audio_player.play(start_point)

func kill_sound(_player):
	_player.stop()
	_player.queue_free()

func play_sound_main_camera(sound:AudioStreamMP3,bus):
	get_camera()
	var new_audio_player:AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	new_audio_player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_DISABLED
	main_camera.add_child(new_audio_player)
	new_audio_player.stream = sound
	new_audio_player.bus = bus
	new_audio_player.pitch_scale = randf_range(new_audio_player.pitch_scale-0.5,new_audio_player.pitch_scale)
	new_audio_player.play(0.0)

func play_music(audio_player:AudioStreamPlayer):
	add_child(audio_player)
	audio_player.play()

func get_camera():
	while (main_camera == null):
		main_camera = get_tree().get_first_node_in_group("MainCamera")
		await get_tree().process_frame
	got_main_camera.emit()
