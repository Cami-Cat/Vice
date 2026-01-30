class_name UiMain
extends Control


@onready var control: Control = $Control

func _ready() -> void:
	await GVar.game_core.ready
	return
