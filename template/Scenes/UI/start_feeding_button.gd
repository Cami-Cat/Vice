extends Button

func _pressed() -> void:
	GVar.signal_bus.game_start.emit()
	return
