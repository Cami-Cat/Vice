class_name PlayerCamera3D
extends Camera3D

@onready var camera_target : Node3D = null
var camera_speed : float = 2.0 # units

func _init() -> void:
	return

func _ready() -> void:
	return

func _process(delta: float) -> void:
	position -= (camera_target.global_position - global_position) * delta
	return

func set_target(in_target : Node3D) -> void:
	camera_target = in_target
	return
