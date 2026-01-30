class_name ManagerBase
extends Node

signal finished_ready(manager)

var scene_manager:SceneManager

func _ready() -> void:
	scene_manager = GVar.get("scene_manager")
	scene_manager.game_ready.connect(_game_ready)
	finished_ready.emit(self)
	name = get_script().get_global_name()
	print(str(self),String(name + " is ready"))

func _game_ready():
	pass
