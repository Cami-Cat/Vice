extends Camera3D

#var game_manager:GameManager
#
#func _physics_process(_delta: float) -> void:
	#if game_manager:
		#look_at_target()
#
#func look_at_target():
	#var target:Vector3 = game_manager.manager_dict[GVar.SUB_MANAGERS.DICE_MANAGER].get_average_dice_point()
	#look_at(target)
