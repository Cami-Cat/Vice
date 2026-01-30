class_name GameCore
extends Node

const SCENE_MANAGER = preload("res://Scenes/Managers/SceneManager/scene_manager.tscn")

var scene_manager:SceneManager

func _ready() -> void:
	GVar.set("game_core",self)
	scene_manager = SCENE_MANAGER.instantiate()
	add_child(scene_manager)
	scene_manager.scene_opened.connect(set_gvar_scene_variables)

func set_gvar_scene_variables():
	GVar.set("active_scene",scene_manager.current_scene)
	GVar.set("active_game_manager",scene_manager.current_scene.game_manager)
	GVar.set("active_signal_bus",scene_manager.current_scene.game_manager.signal_bus)
