class_name PlayerCamera3D
extends Camera3D

@onready var camera_target : Node3D = self.get_parent()
var distance_from_target : float = 50.0 # units
var camera_speed : float = 2.0 # units

func _init() -> void:
	return

func _ready() -> void:
	_validate_camera_target()
	return

func _validate_camera_target() -> void:
	if !is_instance_valid(camera_target):
		var _camera_target = get_tree().get_first_node_in_group("CameraTarget")
		if !_camera_target : return
		else : camera_target = _camera_target
	return
