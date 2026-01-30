class_name ButtonParent extends Button

# @export var button_sound:AudioStreamMP3 = preload("uid://dyl6khb4vxuhn")

@export var sound_array:Array[AudioStreamMP3] = []
var bus = &"SFX"

func _ready() -> void:
	sound_array = []
	pass
	
func _pressed() -> void:
	GSound.play_sound_main_camera(sound_array.pick_random(),bus)
	pass
