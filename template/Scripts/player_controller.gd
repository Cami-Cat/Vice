class_name PlayerController
extends Node

signal _player_controller_ready()
signal _player_controller_init_error()

signal try_possess_pawn(pawn : Pawn)
signal try_unpossess_pawn(pawn : Pawn)

var player_index : int = 0
var possessed_pawn : Pawn = null
var input_manager : InputManager = InputManager.new()
var player_camera : Camera3D = Camera3D.new()

func _init() -> void:
	name = "PlayerController"
	add_child(input_manager)
	player_camera.name = "PlayerCamera"
	GVar.active_scene.upper_canvas.add_child(player_camera)
	return

func _connect_signals() -> void:
	try_possess_pawn.connect(_possess_pawn)
	try_unpossess_pawn.connect(_unpossess_pawn)
	return

func _ready() -> void:
	_game_start()
	return
	
func _game_start() -> void:
	_possess_random_pawn()
	# Alternative implementation is to give the player the ability to select a random pawn from a sky-view of the city.
	return

func _possess_random_pawn() -> void:
	var pawns : Array[Node] = get_tree().get_nodes_in_group("Pawn")
	if !pawns.is_empty():
		var chosen_pawn = pawns.pick_random()
		try_possess_pawn.emit(chosen_pawn)

func _possess_pawn(pawn : Pawn) -> bool:
	if !is_instance_valid(pawn) : return false
	if !pawn.can_possess() : return false
	
	# Do some other camera logic here.
	possessed_pawn = pawn
	pawn._is_possessed = true
	
	return true
	
func _unpossess_pawn(pawn : Pawn) -> bool:
	if !is_instance_valid(pawn) : return false
	if !pawn.can_unpossess() : return false
	
	possessed_pawn = null
	pawn._is_possessed = false
	
	return true
