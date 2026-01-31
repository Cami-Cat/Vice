class_name CharacterModel extends Node3D

@export var scale_varience:float = 0.01

enum ANIM_STATE {
	IDLE,
	WALK,
	RUN,
}

var general_anim_player: AnimationPlayer

const GENERAL_ANIM_PLAYER = preload("res://Scenes/Character/general_anim_player.tscn")


func _ready() -> void:
	var scene_to_instantiate:PackedScene = GVar.character_mesh_array.pick_random()
	var model = scene_to_instantiate.instantiate()
	add_child(model)
	general_anim_player = GENERAL_ANIM_PLAYER.instantiate()
	model.add_child(general_anim_player)
	change_anim(ANIM_STATE.IDLE)
	scale = Vector3(scale * (1.0 + randf_range(-scale_varience,scale_varience)))

func change_anim(anim:ANIM_STATE):
	match anim:
		ANIM_STATE.IDLE:
			general_anim_player.play("Imported_Anim_Library/char_anim_idle")
		ANIM_STATE.WALK:
			general_anim_player.play("Imported_Anim_Library/char_anim_walk")
		ANIM_STATE.RUN:
			general_anim_player.play("Imported_Anim_Library/char_anim_jog")
