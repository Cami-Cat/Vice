class_name PlayerController
extends Node

signal _player_controller_ready()
signal _player_controller_init_error()

var player_index : int = 0
var possessed_pawn : Pawn = null
var input_manager : InputManager = InputManager.new()
var player_camera : PlayerCamera3D = PlayerCamera3D.new()

func _init() -> void:
	name = "PlayerController"
	add_child(input_manager)
	_construct_camera_rig()
	return

func _construct_camera_rig() -> void:
	player_camera.name = "PlayerCamera"
	player_camera.add_to_group("ActiveCamera")
	player_camera.make_current()
	## Below are third person rules.
	#var camera_target : Node3D = Node3D.new()
	#camera_target.name = "CameraTarget"
	#camera_target.add_to_group("CameraTarget")
	
	#camera_target.add_child(player_camera)
	GVar.active_scene.add_child(player_camera)
	return

func _connect_signals() -> void:
	return

func _ready() -> void:
	return
	
func _game_start() -> void:
	print("Game Start!")
	_possess_random_pawn()
	# Alternative implementation is to give the player the ability to select a random pawn from a sky-view of the city.
	return

func _possess_random_pawn() -> void:
	var pawns : Array[Node] = get_tree().get_nodes_in_group("Pawn")
	if !pawns.is_empty():
		var chosen_pawn = pawns.pick_random()
		print("Picking Pawn: %s" % [chosen_pawn])
		_possess_pawn(chosen_pawn)

func _possess_pawn(pawn : Pawn) -> bool:
	if !is_instance_valid(pawn) : 
		print("Pawn is not a valid instance: %s" % [pawn])
		return false
	if !pawn.can_possess() : 
		print("Cannot possess pawn: %s" % [pawn])
		return false
	
	# Do some other camera logic here.
	possessed_pawn = pawn
	pawn._is_possessed = true
	print("Successfully possessed pawn: %s" % [possessed_pawn])
	_set_camera_target(possessed_pawn)
	
	return true
	
func _unpossess_pawn(pawn : Pawn) -> bool:
	if !is_instance_valid(pawn) : return false
	if !pawn.can_unpossess() : return false
	
	possessed_pawn = null
	pawn._is_possessed = false
	
	return true

func _set_camera_target(to : Variant) -> void:	
	if !is_instance_of(to, Pawn) || !typeof(to) != TYPE_VECTOR3:
		print("Cannot set target to: [%s], it must be of type Pawn or Vector3" % [to])
		return
	if is_instance_of(to, Pawn):
		for child : Node in to.get_children():
			if child.is_in_group("CameraTarget"):
				to = child.position
	
	var tween = GTwn._tween_property(player_camera, "position", to, 0.5, Tween.TransitionType.TRANS_SINE)
	await GTwn.kill_tween(tween)
	return
