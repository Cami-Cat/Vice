class_name MovementComponent
extends Node3D

@export var walk_speed : float = 10.0
@export var acceleration : float = 4.0
@export var friction = 2.0

@onready var pawn : Pawn = self.get_parent()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _get_camera_basis() -> Basis:
	return pawn.find_child("CameraTargetComponent").basis

func _physics_process(delta: float) -> void:
	if !pawn.is_on_floor():
		pawn.velocity.y -= (gravity / 100.0) * delta
	
	var input_direction = Input.get_vector("Strafe_Left", "Strafe_Right", "Walk_Forward", "Walk_Backward")
	if input_direction == Vector2.ZERO : 
		pawn.velocity.x = move_toward(pawn.velocity.x, 0, friction * delta) 
		pawn.velocity.z = move_toward(pawn.velocity.z, 0, friction * delta)
			
	var direction = (_get_camera_basis() * Vector3(input_direction.x, 0.0, input_direction.y)).normalized()
	
	pawn.velocity.x = move_toward(pawn.velocity.x, direction.x * walk_speed, delta)
	pawn.velocity.z = move_toward(pawn.velocity.z, direction.z * walk_speed, delta)
	pawn.move_and_slide()
