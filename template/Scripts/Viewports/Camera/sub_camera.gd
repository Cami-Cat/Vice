@tool
class_name Sub_Camera
extends Camera3D

@export var main_camera : Camera3D

func _process(_delta: float) -> void:
	if main_camera:
		self.global_transform = main_camera.global_transform
