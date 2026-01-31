class_name pawn_AI
extends Node3D

signal behaviour_chosen()
signal idle_timeout()

static var world_bounds : float = 100.0

@export var ai_walk_speed : float = 2.0
@export var max_idle_time : float = 15.0
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var pawn : Pawn = self.get_parent()

var should_navigate : bool = true
var just_idled : bool = false
var alerted : bool = false
var is_shooting : bool = false

var player_raycast : RayCast3D

enum AI_TYPE {CITIZEN, HUNTER}
@export var ai_type : AI_TYPE

enum BEHAVIOUR {IDLE, WALK, FLEE, HUNTING, AIMING}
var current_behaviour : BEHAVIOUR

func _init() -> void:
	idle_timeout.connect(choose_next_behaviour)
	behaviour_chosen.connect(_do_behaviour)
	_construct_raycast()
	return

func choose_next_behaviour() -> void:
	if pawn.is_dead : return
	current_behaviour = BEHAVIOUR.IDLE
	match ai_type:
		AI_TYPE.CITIZEN:
			if !just_idled:
				current_behaviour = randi_range(0, 1) as BEHAVIOUR
			else:
				just_idled = false
				if alerted:
					current_behaviour = BEHAVIOUR.FLEE
				else:
					current_behaviour = BEHAVIOUR.WALK
		AI_TYPE.HUNTER:
			if !just_idled:
				current_behaviour = randi_range(0, 1) as BEHAVIOUR
			else:
				just_idled = false
				if alerted:
					current_behaviour = BEHAVIOUR.HUNTING
				else:
					current_behaviour = BEHAVIOUR.WALK
	
	behaviour_chosen.emit()
	return

func _construct_raycast() -> void:
	player_raycast = RayCast3D.new()
	player_raycast.position.y += 1.5
	add_child(player_raycast)
	return

func _can_see_player_pawn() -> bool:
	var player_pawn : Pawn = GVar.player_controller.possessed_pawn
	var direction = (player_pawn.global_position - pawn.global_position).normalized() 
	player_raycast.target_position = direction * 20.0
	if player_raycast.is_colliding():
		if player_raycast.get_collider() != player_pawn: return false
		return true
	return false
	
func _ready() -> void:
	navigation_agent_3d.navigation_finished.connect(choose_next_behaviour)
	pawn.is_possessed.connect(_pause_ai)
	pawn.is_unpossessed.connect(_unpause_ai)
	just_idled = true
	await get_tree().create_timer(0.5).timeout
	choose_next_behaviour()
	return

func _do_behaviour() -> void:
	match current_behaviour:
		BEHAVIOUR.IDLE:
			_idle()
		BEHAVIOUR.WALK:
			_set_target_position()
		BEHAVIOUR.FLEE:
			idle_timeout.emit()
	return

func _idle() -> void:
	var idle_time = randf_range(3.0, max_idle_time)
	await get_tree().create_timer(idle_time).timeout
	just_idled = true
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
	if !should_navigate : return
	if current_behaviour == BEHAVIOUR.HUNTING:
		navigation_agent_3d.set_target_position(GVar.player_controller.possessed_pawn.global_position)
		return
	navigation_agent_3d.set_target_position(_get_random_position_in_world())
	return

func _go_to_target_position() -> void:
	if pawn.is_dead : return
	if !should_navigate : 
		pawn.velocity = Vector3.ZERO
		return
	var target_position = navigation_agent_3d.get_next_path_position()
	var local_position = target_position - global_position
	var direction = (local_position.normalized() * ai_walk_speed)
	
	navigation_agent_3d.set_velocity(direction)
	return

func _physics_process(delta: float) -> void:
	if pawn.is_dead : 
		pawn.velocity = Vector3.ZERO
		return
	elif current_behaviour == BEHAVIOUR.HUNTING:
		if _can_see_player_pawn():
			current_behaviour = BEHAVIOUR.AIMING
		else:
			_set_target_position()
	elif current_behaviour == BEHAVIOUR.AIMING:
		_aim_at_player()
	if !should_navigate: return
	elif current_behaviour == BEHAVIOUR.WALK || current_behaviour == BEHAVIOUR.FLEE || current_behaviour == BEHAVIOUR.HUNTING:
		_go_to_target_position()

func _aim_at_player() -> void:
	if _can_see_player_pawn():
		should_navigate = false
		if is_shooting : return
		is_shooting = true
		await _shoot_at_player()
	else:
		current_behaviour == BEHAVIOUR.HUNTING
		should_navigate = true
		is_shooting = false

func _shoot_at_player() -> void:
	# Aiming cooldown
	await get_tree().create_timer(randf_range(1.0, 2.5)).timeout
	if player_raycast.is_colliding() && player_raycast.get_collider() is Pawn:
		player_raycast.get_collider().die()
		# Shooting cooldown
		await get_tree().create_timer(randf_range(1.5, 3.5)).timeout
		is_shooting = false

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	if pawn.is_dead : return
	if !should_navigate : 
		pawn.velocity = Vector3.ZERO
		return
	pawn.velocity = pawn.velocity.move_toward(safe_velocity, 0.75)
	pawn.move_and_slide()
	return
