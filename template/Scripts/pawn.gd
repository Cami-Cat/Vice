class_name Pawn
extends CharacterBody3D

const SND_PLAYER_MASK_OFF = preload("res://Assets/Audio/SFX/Raw/snd_player_mask_off.wav")
const SND_PLAYER_MASK_ON = preload("res://Assets/Audio/SFX/Raw/snd_player_mask_on.wav")
const SND_FEMALE_HURT_01 = preload("res://Assets/Audio/SFX/Raw/FemaleOuchies/snd_female_hurt_01.wav")
const SND_FEMALE_HURT_02 = preload("res://Assets/Audio/SFX/Raw/FemaleOuchies/snd_female_hurt_02.wav")
const SND_FEMALE_HURT_03 = preload("res://Assets/Audio/SFX/Raw/FemaleOuchies/snd_female_hurt_03.wav")
const SND_MALE_HURT_01 = preload("res://Assets/Audio/SFX/Raw/MaleOuchies/snd_male_hurt_01.wav")
const SND_MALE_HURT_02 = preload("res://Assets/Audio/SFX/Raw/MaleOuchies/snd_male_hurt_02.wav")
const SND_MALE_HURT_03 = preload("res://Assets/Audio/SFX/Raw/MaleOuchies/snd_male_hurt_03.wav")
const SND_PLAYER_BITE = preload("res://Assets/Audio/SFX/Raw/snd_player_bite.wav")


const female_hurt_array:Array = [SND_FEMALE_HURT_01,SND_FEMALE_HURT_02,SND_FEMALE_HURT_03]
const male_hurt_array:Array = [SND_MALE_HURT_01,SND_MALE_HURT_02,SND_MALE_HURT_03]

signal is_possessed()
signal is_unpossessed()

@export var _can_possess : bool = true

@onready var character_model: CharacterModel = $CharacterModel
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var funny_box: MeshInstance3D = $"CharacterModel/Funny box"

@onready var movement_component: MovementComponent = $MovementComponent
@onready var pawn_ai: pawn_AI = $PawnAI

var hunger:Hunger = null
var mask_on:bool = true
var toggle_mask_on_cooldown:bool = false

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
	if _is_possessed:
		GVar.signal_bus.player_died.emit()
	else:
		GVar.signal_bus.pawn_died.emit()
		character_model.change_anim(character_model.ANIM_STATE.DIE)
	if character_model.is_woman:
		GSound.play_sound(&"SFX",female_hurt_array.pick_random())
	else:
		GSound.play_sound(&"SFX",male_hurt_array.pick_random())
	lay_hitbox_down()

func lay_hitbox_down():
	collision_shape_3d.global_position = funny_box.global_position
	collision_shape_3d.rotation = funny_box.global_rotation

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
	pawn_ai.queue_free()

func action():
	var pawn:Pawn = GVar.player_context_raycast.hovered_pawn
	if pawn:
		if mask_on:
			_talk()
		else:
			_attack(pawn)
			GSound.play_sound(&"SFX",SND_PLAYER_BITE)
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
		print("ATTACK")
		pawn.is_dead = true

func _feed():
	pass

func _whistle():
	pass

func _scream():
	pass

func _talk():
	print("UWU")

func start_toggle_mask_cooldown():
	toggle_mask_on_cooldown = true
	var cooldown_timer:Timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.start(1.0)
	await cooldown_timer.timeout
	toggle_mask_on_cooldown = false
	cooldown_timer.queue_free()

func toggle_mask():
	if toggle_mask_on_cooldown:
		return
	else:
		start_toggle_mask_cooldown()
	var desired_mask:bool = !mask_on
	# wrote shit for readability
	if desired_mask == true:
		if hunger.current_hunger > hunger.hunger_threshold_to_mask:
			mask_on = desired_mask
			GVar.signal_bus.mask_changed.emit(GVar.MASK.MASK_ON)
			GSound.play_sound(&"SFX",SND_PLAYER_MASK_ON)
			print("I put the mask on")
		else:
			print("Me still hungy")
	else:
		mask_on = desired_mask
		GVar.signal_bus.mask_changed.emit(GVar.MASK.MASK_OFF)
		GSound.play_sound(&"SFX",SND_PLAYER_MASK_OFF)
		print("I take the mask off")
	pass

func change_visibilty(to : bool = false) -> void:
	character_model.visible = to
	return
