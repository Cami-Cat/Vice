extends Node

enum SUB_MANAGERS {
	UI_MANAGER,
	INPUT_MANAGER,
}

## Layer enums for quick layer selection
enum LAYERS {
	## Upper most layer should always be ontop 999
	DEBUG,
	## Should only be below any debug information 998
	TRANSITION,
	## Only ever covered by debug and transition screens 997
	PRIMARY,
	## Holds lower layer and all post processing affects that will affect both UI and world space, think VHS filter 99
	UPPER,
	## Holds UI 10
	LOWER,
}

static var sub_manager_dict : Dictionary = {
	SUB_MANAGERS.UI_MANAGER:UIManager,
	SUB_MANAGERS.INPUT_MANAGER:InputManager,
}

## int assosciated with the Layer
const LAYER_DICT:Dictionary[LAYERS,int] = {
	LAYERS.DEBUG:999,
	LAYERS.TRANSITION:998,
	LAYERS.PRIMARY:997,
	LAYERS.UPPER:99,
	LAYERS.LOWER:10,
}
var game_core:GameCore:
	get:
		return game_core
	set(value):
		game_core = value

var scene_manager:SceneManager:
	get:
		return scene_manager
	set(value):
		scene_manager = value

var active_scene:SceneBase:
	get:
		return active_scene
	set(value):
		active_scene = value

var game_manager:GameManager:
	get:
		return game_manager
	set(value):
		game_manager = value

var signal_bus:SignalBus:
	get:
		return signal_bus
	set(value):
		signal_bus = value

var main_viewport:MainViewport:
	get:
		return main_viewport
	set(value):
		main_viewport = value

var world_origin:WorldOrigin:
	get:
		return world_origin
	set(value):
		world_origin = value
