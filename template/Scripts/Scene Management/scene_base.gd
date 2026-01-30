class_name SceneBase
extends Node

const GAME_MANAGER = preload("res://Scenes/Managers/GameManager/game_manager.tscn")

signal scene_ready()

var game_manager:GameManager
var signal_bus:SignalBus

func _ready() -> void:
	game_manager = GAME_MANAGER.instantiate()
	add_child(game_manager)
	await game_manager.all_managers_ready
	signal_bus = game_manager.signal_bus
	scene_ready.emit()

func close_scene():
	queue_free()
