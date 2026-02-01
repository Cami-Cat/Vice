extends Area3D

var timed_out:bool = false

func _on_body_entered(_body: Node3D) -> void:
	if timed_out: return
	GVar.signal_bus.hunter_near_player.emit(global_position)
	create_timeout()

func create_timeout():
	timed_out = true
	var timer:Timer = Timer.new()
	add_child(timer)
	timer.start(3.0)
	await timer.timeout
	timed_out = false
