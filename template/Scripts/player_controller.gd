class_name PlayerController
extends Node

signal player_pawn_selected(pawn : Pawn)

var player_index : int = 0
var possessed_pawn : Pawn = null
var player_camera : PlayerCamera3D = PlayerCamera3D.new()

func _init() -> void:
	name = "PlayerController"
	_construct_camera_rig()
	return

func _construct_input_handler() -> void:
	var input_manager = InputManager.new(self)
	add_child(input_manager)
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
	var context_raycast:ContextRayCast3D = ContextRayCast3D.new()
	player_camera.add_child(context_raycast)
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
	if possessed_pawn != null:
		if !_unpossess_pawn(possessed_pawn):
			print("Cannot unpossess currently possessed pawn: %s" % [possessed_pawn])
			return false
			
	possessed_pawn = pawn
	possessed_pawn.change_visibilty(false)
	var audio_listener:AudioListener3D = AudioListener3D.new()
	possessed_pawn.add_child(audio_listener)
	pawn._is_possessed = true
	print("Successfully possessed pawn: %s" % [possessed_pawn])
	_set_camera_target(possessed_pawn)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player_pawn_selected.emit(possessed_pawn)
	return true
	
func _unpossess_pawn(pawn : Pawn) -> bool:
	if !is_instance_valid(pawn) : return false
	if !pawn.can_unpossess() : return false
	
	possessed_pawn = null
	pawn._is_possessed = false
	
	return true

func _set_camera_target(to : Variant) -> void:
	var _type : Variant
	if !is_instance_of(to, Pawn) || !typeof(to) != TYPE_VECTOR3:
		print("Cannot set target to: [%s], it must be of type Pawn or Vector3" % [to])
		return
	if is_instance_of(to, Pawn):
		for component : Node in to.get_children():
			if !component.is_in_group("CameraTarget") : continue
			to = component
			break
	
	player_camera.set_target(to)
	
	if is_instance_of(to, Node3D):
		# This ensures that the position is constantly updated.
		player_camera.get_parent().remove_child(player_camera)
		to.add_child(player_camera)
	return

func _remove_camera_from_parent() -> bool:
	player_camera.get_parent().remove_child(player_camera)
	if player_camera.get_parent() == null : return true
	return false
