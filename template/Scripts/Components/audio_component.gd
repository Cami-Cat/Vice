class_name AudioComponent
extends Node

enum AUDIO_BUSSES {SFX, MUSIC, AMBIENCE, UI}

static var audio_bus_dict : Dictionary[AUDIO_BUSSES, StringName] = {
	AUDIO_BUSSES.SFX : &"SFX",
	AUDIO_BUSSES.MUSIC : &"Music",
	AUDIO_BUSSES.AMBIENCE : &"Ambience",
	AUDIO_BUSSES.UI : &"UI",
}

@export_group("Audio Settings")
## All the possible sounds that can be played from this object.
@export var audio_array : Array[AudioStream]
## The bus that these sounds will be played from.
@export var audio_bus : AUDIO_BUSSES = AUDIO_BUSSES.SFX

## Input argument should be of type:[br]
## [Node] (with position)[br]
## [member Vector2][br]
## [member Vector3]
func _play_sound(sound : AudioStream, ...args : Array) -> void:
	GSound.play_sound(audio_bus_dict[audio_bus], sound, args)
	return

## Returns a random sound within the [member audio_array]
func _get_random_sound() -> AudioStream:
	return audio_array.pick_random()
