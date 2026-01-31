class_name NPCSpawner
extends Node3D

signal spawn_complete()

const PAWN_SCENE = preload("res://Scenes/Character/Pawn.tscn")

@export var hunter_chance : float = 0.05 ## Chance for a hunter to be chosen out of 0.0 - 1.0
@export var spawn_rate : float = 0.2 ## How long to wait between spwaning?
@export var spawn_while_visible : bool ## Spawn while you're seen?
@export var ready_spawn_count : int = 10 ## Hopw many to spawn on ready.
@export var spawn_limit : int = 25

func _ready() -> void:
	_initial_spawn()
	_start_spawning()
	spawn_complete.connect(_start_spawning)
	return

func _initial_spawn() -> void:
	for i in range(ready_spawn_count):
		_spawn_npc()
	return
	
func _start_spawning() -> void:
	await get_tree().create_timer(spawn_rate).timeout
	_spawn_npc()
	return

func _spawn_npc() -> void:
	if self.get_children().size() > spawn_limit :
		await GVar.signal_bus.pawn_died
	var pawn_type : pawn_AI.AI_TYPE = pawn_AI.AI_TYPE.CITIZEN
	var random_number = randf_range(0.0, 1.0)
	if random_number < hunter_chance:
		pawn_type = pawn_AI.AI_TYPE.HUNTER
		
	var pawn : Pawn = PAWN_SCENE.instantiate()
	self.add_child(pawn)
	pawn.pawn_ai.ai_type = pawn_type
	pawn.global_position = self.global_position
	spawn_complete.emit()
	return
