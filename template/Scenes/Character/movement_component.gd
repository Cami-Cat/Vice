class_name MovementComponent
extends Node3D

@export var max_walk_speed : float = 200.0
@export var max_run_speed: float = 500.0

@onready var pawn : Pawn = self.get_parent()

var disabled = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if pawn.is_dead: return
	if !pawn.is_on_floor():
		pawn.velocity.y -= (gravity / 100.0) * delta
	pawn.move_and_slide()

func toggle_disabled(state:bool) -> void:
	disabled = state
	pass
