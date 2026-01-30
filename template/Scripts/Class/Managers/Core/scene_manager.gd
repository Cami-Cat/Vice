class_name SceneManager
extends ManagerBase

signal scene_opened()
signal game_ready()

const DEFAULT_SCENE:PackedScene = preload("res://Scenes/BaseScene/scene_base.tscn")
var current_scene:SceneBase

@onready var primary_canvas_layer_node: CanvasLayer = $PrimaryCanvasLayerNode
@onready var transition_screen: TransitionScreen = $"Transition layer/transition_screen"

func _ready() -> void:
	GVar.set("scene_manager",self)
	super()
	open_default_scene()
	
func open_default_scene():
	var new_scene = DEFAULT_SCENE.instantiate()
	open_scene(new_scene)

func open_scene(scene_to_open : SceneBase) -> void:
	fnc_transition_screen(true)
	await transition_screen.screen_hidden
	#loading the level
	close_current_scene()
	primary_canvas_layer_node.add_child(scene_to_open)
	current_scene = scene_to_open
	if !current_scene.is_node_ready():
		await current_scene.scene_ready
	
	scene_opened.emit()
	game_ready.emit()
	fnc_transition_screen(false)
	await transition_screen.screen_visible

func close_current_scene():
	if current_scene != null:
		var scene_child:SceneBase = primary_canvas_layer_node.get_child(0)
		scene_child.close_scene()

func fnc_transition_screen(hide_screen:bool):
	transition_screen.transition_screen(hide_screen)
