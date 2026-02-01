class_name CharacterModel extends Node3D

@export var scale_varience:float = 0.01

enum ANIM_STATE {
	IDLE,
	WALK,
	RUN,
	DIE,
	IDLE_GUN,
	WALK_GUN,
	RUN_GUN,
}

var is_woman:bool = true

var general_anim_player: AnimationPlayer

const GENERAL_ANIM_PLAYER = preload("res://Scenes/Character/general_anim_player.tscn")

func _ready() -> void:
	while (get_parent().pawn_ai == null):
		await get_tree().process_frame
	var scene_to_instantiate:PackedScene
	if get_parent().pawn_ai.ai_type == get_parent().pawn_ai.AI_TYPE.HUNTER:
		scene_to_instantiate = GVar.character_mesh_array_s[0]
	else:
		var _randi:int = randi_range(0,1)
		if _randi == 0:
			is_woman = false
		if is_woman:
			scene_to_instantiate = GVar.character_mesh_array_f.pick_random()
		else:
			scene_to_instantiate = GVar.character_mesh_array_m.pick_random()
	var model = scene_to_instantiate.instantiate()
	add_child(model)
	general_anim_player = GENERAL_ANIM_PLAYER.instantiate()
	model.add_child(general_anim_player)
	change_anim(ANIM_STATE.IDLE)
	scale = Vector3(scale * (1.0 + randf_range(-scale_varience,scale_varience)))

func get_skeleton() -> Skeleton3D:
	var child = get_child(0)
	return child.get_child(0)

func change_anim(anim:ANIM_STATE):
	match anim:
		ANIM_STATE.IDLE:
			general_anim_player.play("Imported_Anim_Library/char_anim_idle")
		ANIM_STATE.WALK:
			general_anim_player.play("Imported_Anim_Library/char_anim_walk")
		ANIM_STATE.RUN:
			general_anim_player.play("Imported_Anim_Library/char_anim_jog")
		ANIM_STATE.DIE:
			var t_array:Array[String] = ["Imported_Anim_Library/char_anim_death_1","Imported_Anim_Library/char_anim_death_2"]
			general_anim_player.play(t_array.pick_random())
		ANIM_STATE.IDLE_GUN:
			general_anim_player.play("Imported_Anim_Library/char_anim_rifle_idle")
		ANIM_STATE.WALK_GUN:
			general_anim_player.play("Imported_Anim_Library/char_anim_rifle_walk")
		ANIM_STATE.RUN_GUN:
			general_anim_player.play("Imported_Anim_Library/char_anim_rifle_run")
