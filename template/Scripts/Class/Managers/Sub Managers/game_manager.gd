class_name GameManager
extends ManagerBase

const GAME_MUSIC_AUDIO_PLAYER = preload("res://Assets/Audio/Music/game_music_audio_player.tscn")
const MUSIC_PLAYER_DEATH = preload("res://Assets/Audio/SFX/Raw/music_playerDeath.ogg")

signal all_managers_ready()

var managers_to_load:Array[GVar.SUB_MANAGERS] = [GVar.SUB_MANAGERS.UI_MANAGER]
var manager_dict:Dictionary[GVar.SUB_MANAGERS,ManagerBase]
var managers_ready_state_dict:Dictionary

enum STATES {LOADING, READY}

var current_state : STATES

#@onready var world_viewport: SubViewportContainer = $"../World Viewport"
@onready var signal_bus: SignalBus = $SignalBus

#func _load_managers() -> void:
	#var managers = GVar.sub_manager_dict.keys()
	#for manager in managers:
		#var new_manager = GVar.sub_manager_dict[manager].new()
	#return

func _ready() -> void:
	create_sub_managers()
	await all_managers_ready
	_construct_player_controller()
	GVar.set("game_manager",self)
	GVar.set("signal_bus",signal_bus)
	super()
	_game_ready()
	signal_bus.game_ready.emit()
	signal_bus.player_died.connect(player_died)

func player_died():
	GSound.play_sound(&"SFX",MUSIC_PLAYER_DEATH)

func create_sub_managers():
	for key in managers_to_load:
		var value = GVar.sub_manager_dict[key]
		var new_manager:ManagerBase = value.new()
		new_manager.finished_ready.connect(sub_manager_ready)
		add_child(new_manager)
		manager_dict[key] = new_manager

func sub_manager_ready(sub_manager:ManagerBase):
	managers_ready_state_dict[sub_manager] = true
	call_deferred("check_all_managers_ready")

func check_all_managers_ready():
	if (managers_ready_state_dict.size() == managers_to_load.size() && managers_ready_state_dict.values().all(GFnc.all_true)):
		all_managers_ready.emit()

func _construct_player_controller() -> void:
	var player_controller : PlayerController = PlayerController.new()
	signal_bus.game_ready.connect(player_controller._game_start)
	GVar.set("player_controller", player_controller)
	add_child(player_controller)

func _game_ready():
	GSound.play_music(GAME_MUSIC_AUDIO_PLAYER.instantiate())
	pass

func _game_end():
	pass
