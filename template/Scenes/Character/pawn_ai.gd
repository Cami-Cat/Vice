class_name pawn_AI
extends Node3D

signal behaviour_chosen()
signal idle_timeout()

static var world_bounds : float = 100.0

@export var ai_walk_speed : float = 5.0

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var pawn : Pawn = self.get_parent()
var should_navigate : bool = true

enum BEHAVIOUR {IDLE, WALK, FLEE}
var current_behaviour : BEHAVIOUR

func _init() -> void:
	idle_timeout.connect(choose_next_behaviour)
	behaviour_chosen.connect(_do_behaviour)
	return

func choose_next_behaviour() -> void:
	current_behaviour = BEHAVIOUR.IDLE
	current_behaviour = randi_range(0, 2) as BEHAVIOUR
	print("%s Choosing Pawn behaviour: %s" % [pawn.name, BEHAVIOUR.keys()[int(current_behaviour)]])
	behaviour_chosen.emit()
	return

func _ready() -> void:
	navigation_agent_3d.navigation_finished.connect(choose_next_behaviour)
	pawn.is_possessed.connect(_pause_ai)
	pawn.is_unpossessed.connect(_unpause_ai)
	choose_next_behaviour()
	return

func _do_behaviour() -> void:
	match current_behaviour:
		BEHAVIOUR.IDLE:
			idle_timeout.emit()
		BEHAVIOUR.WALK:
			_set_target_position()
		BEHAVIOUR.FLEE:
			idle_timeout.emit()
	return

func _pause_ai() -> void:
	if should_navigate : should_navigate = false
	return

func _unpause_ai() -> void:
	if !should_navigate : should_navigate = true
	return

func _get_random_position_in_world() -> Vector3:
	var random_pos : Vector3 = Vector3.ZERO
	random_pos.x = randf_range(-world_bounds, world_bounds)
	random_pos.z = randf_range(-world_bounds, world_bounds)
	return random_pos

func _set_target_position() -> void:
	navigation_agent_3d.set_target_position(_get_random_position_in_world())
	print("%s: Target position selected: %s" % [pawn.name, navigation_agent_3d.target_position])
	return

func _go_to_target_position() -> void:
	var target_position = navigation_agent_3d.get_next_path_position()
	var local_position = target_position - global_position
	var direction = local_position.normalized()
	
	pawn.velocity = direction * ai_walk_speed
	return

func _physics_process(delta: float) -> void:
	if !should_navigate : return
	if current_behaviour == BEHAVIOUR.WALK || current_behaviour == BEHAVIOUR.FLEE:
		_go_to_target_position()
