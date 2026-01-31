class_name Pawn
extends Node

@export var _can_possess : bool = true
@export var death_sound : AudioStream

@onready var character_model: CharacterModel = $CharacterModel

@onready var movement_component: MovementComponent = $MovementComponent

var hunger:Hunger = null
var mask_on:bool = true

var is_dead:bool = false:
	set(value):
		is_dead = value
		die()

var _is_possessed : bool = false:
	set(value):
		_is_possessed = value
		possessed()

func can_possess() -> bool:
	return true if _can_possess else false

func can_unpossess() -> bool:
	return true if _is_possessed else false

func die():
	if death_sound:
		GSound.play_sound(&"SFX",death_sound)
	print("I have been killed")

func possessed():
	hunger = Hunger.new()
	add_child(hunger)
	var action_component:ActionComponent = ActionComponent.new()
	movement_component.queue_free()
	movement_component = MovementComponentPlayer.new()
	add_child(movement_component)
	add_child(action_component)
	action_component.mask_action_pressed.connect(toggle_mask)
	action_component.lclick_action_pressed.connect(action)

func change_visibilty(state:bool):
	character_model.visible = state
	pass

func action():
	var pawn:Pawn = GVar.player_context_raycast.hovered_pawn
	if pawn:
		if mask_on:
			_talk()
		else:
			_attack(pawn)
	else:
		if mask_on:
			_whistle()
		else:
			_scream()
	pass

func _attack(pawn:Pawn):
	if pawn.is_dead:
		_feed()
	else:
		pawn.is_dead = true

func _feed():
	pass

func _whistle():
	pass

func _scream():
	pass

func _talk():
	print("UWU")

func toggle_mask():
	var desired_mask:bool = !mask_on
	# wrote shit for readability
	if desired_mask == true:
		if hunger.current_hunger > hunger.hunger_threshold_to_mask:
			mask_on = desired_mask
			GVar.signal_bus.mask_changed.emit(GVar.MASK.MASK_ON)
			print("I put the mask on")
		else:
			print("Me still hungy")
	else:
		mask_on = desired_mask
		GVar.signal_bus.mask_changed.emit(GVar.MASK.MASK_OFF)
		print("I take the mask off")
	pass
