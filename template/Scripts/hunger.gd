class_name Hunger extends Node3D

@warning_ignore("unused_signal")
signal hunger_empty
signal hunger_above_threshold
signal hunger_below_threshold

@export var max_hunger:float = 100.0
@export var hunger_decay:float = 1.0
@export var hunger_decay_interval:float = 1.0
@export var hunger_threshold_for_forced_maskoff:float = 25.0
@export var hunger_threshold_to_mask:float = 25.0

var hunger_timer:Timer

@onready var current_hunger:float = max_hunger

func _ready() -> void:
	hunger_timer = Timer.new()
	add_child(hunger_timer)
	hunger_timer.wait_time = hunger_decay_interval
	hunger_timer.one_shot = false
	hunger_timer.timeout.connect(hunger)
	hunger_timer.start()

func hunger():
	current_hunger -= hunger_decay
	GVar.signal_bus.hunger_changed.emit(current_hunger/max_hunger)
	if current_hunger <= 0.0:
		hunger_empty.emit()
	if current_hunger < hunger_threshold_for_forced_maskoff:
		hunger_below_threshold.emit()

func feed(hunger_value:float):
	current_hunger += hunger_value
	if current_hunger > max_hunger:
		current_hunger = max_hunger
	if current_hunger > hunger_threshold_to_mask:
		hunger_above_threshold.emit()
