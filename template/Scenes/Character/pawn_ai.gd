class_name pawn_AI
extends Node3D

signal behaviour_chosen()
signal idle_timeout()
signal shot()

static var world_bounds : float = 100.0

const AI_WALK_SPEED : float = 2.0
const AI_RUN_SPEED : float = 4.0

@export var ai_speed : float = 2.0
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
				if alerted : current_behaviour = BEHAVIOUR.FLEE
			else:
				just_idled = false
				if alerted : current_behaviour = BEHAVIOUR.FLEE
				else : current_behaviour = BEHAVIOUR.WALK
		AI_TYPE.HUNTER:
			if !just_idled : 
				current_behaviour = randi_range(0, 1) as BEHAVIOUR
				if alerted : current_behaviour = BEHAVIOUR.HUNTING
			else:
				just_idled = false
				if alerted : current_behaviour = BEHAVIOUR.HUNTING
				else : current_behaviour = BEHAVIOUR.WALK
	
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
	player_raycast.collision_mask = 2
	if player_raycast.is_colliding():
		if player_raycast.get_collider() != player_pawn: 
			return false
		print("Colliding with: %s" % player_raycast.get_collider()) 
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

func _alert(mask_state : GVar.MASK) -> void:
	match mask_state:
		GVar.MASK.MASK_ON:
			return
		GVar.MASK.MASK_OFF:
			alerted = true
			choose_next_behaviour()
	return

func _do_behaviour() -> void:
	match current_behaviour:
		BEHAVIOUR.IDLE:
			_idle()
			if ai_type == AI_TYPE.CITIZEN:
				pawn.character_model.change_anim(CharacterModel.ANIM_STATE.IDLE)
			else:
				pawn.character_model.change_anim(CharacterModel.ANIM_STATE.IDLE_GUN)
		BEHAVIOUR.WALK:
			ai_speed = AI_WALK_SPEED
			_set_target_position()
			if ai_type == AI_TYPE.CITIZEN:
				pawn.character_model.change_anim(CharacterModel.ANIM_STATE.WALK)
			else:
				pawn.character_model.change_anim(CharacterModel.ANIM_STATE.WALK_GUN)
		BEHAVIOUR.HUNTING:
			ai_speed = AI_WALK_SPEED
			_set_target_position()
			pawn.character_model.change_anim(CharacterModel.ANIM_STATE.WALK_GUN)
		BEHAVIOUR.FLEE:
			ai_speed = AI_RUN_SPEED
			pawn.character_model.change_anim(CharacterModel.ANIM_STATE.RUN)
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
	var direction = (local_position.normalized() * ai_speed)
	
	navigation_agent_3d.set_velocity(direction)
	return

func _physics_process(_delta: float) -> void:
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
	elif current_behaviour == BEHAVIOUR.FLEE:
		var distance_from_player = GVar.player_controller.possessed_pawn.global_position - pawn.global_position
		if abs(distance_from_player.x + distance_from_player.z) > 40.0 : 
			alerted = false
			current_behaviour = BEHAVIOUR.WALK
			_do_behaviour()
			_set_target_position()
			return
		var direction_to_player = (GVar.player_controller.possessed_pawn.global_position - pawn.global_position).normalized()
		var run_location = pawn.global_position - (direction_to_player * 10.0)
		navigation_agent_3d.set_target_position(run_location)
		_go_to_target_position()
	elif current_behaviour == BEHAVIOUR.WALK || current_behaviour == BEHAVIOUR.FLEE || current_behaviour == BEHAVIOUR.HUNTING:
		_go_to_target_position()

func _aim_at_player() -> void:
	if _can_see_player_pawn():
		should_navigate = false
		if is_shooting : return
		is_shooting = true
		await _shoot_at_player()
	else:
		if is_shooting : await shot
		current_behaviour = BEHAVIOUR.HUNTING
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
	shot.emit()
	
func _player_dead() -> void:
	current_behaviour = BEHAVIOUR.WALK
	is_shooting = false
	should_navigate = true
	_do_behaviour()
	return

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	if pawn.is_dead : return
	if !should_navigate : 
		pawn.velocity = Vector3.ZERO
		return
	pawn.velocity = pawn.velocity.move_toward(safe_velocity, 0.75)
	if !(pawn.global_position - safe_velocity).is_equal_approx(pawn.global_position) :
		pawn.character_model.look_at(pawn.global_position - safe_velocity)
	pawn.move_and_slide()
	return
