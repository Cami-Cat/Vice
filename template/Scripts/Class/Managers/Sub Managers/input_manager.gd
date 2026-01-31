class_name InputManager
extends ManagerBase

var player_controller : PlayerController = null
var controlled_pawn : Pawn = null

## @deprecated For now this should remain that way, but it's possible to use this in the future, for things to do with just UI perhaps.
func _init(_player_controller : PlayerController = null) -> void:
	if _player_controller == null : 
		print("To create an Input Manager, please pass the current PlayerController as an argument.")
		queue_free()
		return
	player_controller = _player_controller
	return
