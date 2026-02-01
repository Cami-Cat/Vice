class_name CameraTarget 
extends Node3D

@export var camera_rotation_speed : float = 0.5
@onready var parent_node : Node3D = self.get_parent()

var _camera_input_dir : Vector2 = Vector2.ZERO
var disabled:bool = false
func _unhandled_input(event: InputEvent) -> void:
	if disabled: return
	if event is InputEventMouseMotion:
		_camera_input_dir = event.screen_relative * camera_rotation_speed

func _physics_process(delta: float) -> void:
	rotation.x -= _camera_input_dir.y * delta
	rotation.x = clamp(rotation.x, -PI/2, PI/2)
	rotation.y -= _camera_input_dir.x * delta
	_camera_input_dir = Vector2.ZERO
