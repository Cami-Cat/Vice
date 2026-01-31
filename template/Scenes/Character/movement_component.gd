class_name MovementComponent
extends Node3D

@export var walk_speed : float = 10.0
@export var acceleration : float = 4.0
@export var friction = 2.0

@onready var pawn : Pawn = self.get_parent()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if !pawn.is_on_floor():
		pawn.velocity.y -= (gravity / 100.0) * delta
	pawn.move_and_slide()
