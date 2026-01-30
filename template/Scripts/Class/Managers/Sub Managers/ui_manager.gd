class_name UIManager
extends ManagerBase

const UI_MAIN = preload("res://Scenes/UI/ui_main.tscn")

var signal_bus : SignalBus

var canvas_layer : CanvasLayer
var ui_main : UiMain

func _ready() -> void:
	await create_canvas_layer()
	await create_ui_main()
	super()

func _game_ready():
	signal_bus = GVar.get("active_signal_bus")
	signal_bus.roll_requested.connect(ui_main.can_roll)
	signal_bus.score_changed.connect(ui_main.update_score)
	signal_bus.score_required_changed.connect(ui_main.update_score_required)
	pass

func create_ui_main():
	ui_main = UI_MAIN.instantiate()
	canvas_layer.call_deferred("add_child",ui_main)
	await ui_main.ready

func create_canvas_layer():
	canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 4096
	call_deferred("add_child", canvas_layer)
	await canvas_layer.ready
