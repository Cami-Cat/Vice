class_name DebugCanvasLayer
extends AutoLayer

const FPS_COUNTER = preload("res://Scenes/Utility/FpsCounter/fps_counter.tscn")


func _ready() -> void:
	super()
	create_fps_counter()

func create_fps_counter():
	add_child(FPS_COUNTER.instantiate())
