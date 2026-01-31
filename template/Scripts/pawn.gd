class_name Pawn
extends Node

@onready var mesh: MeshInstance3D = $Mesh
@export var _can_possess : bool = true
var _is_possessed : bool = false

func can_possess() -> bool:
	return true if _can_possess else false

func can_unpossess() -> bool:
	return true if _is_possessed else false
