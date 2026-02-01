class_name UiMain
extends Control

@onready var blur_effect: ColorRect = $BlurEffect
@onready var control: Control = $Control
@onready var mask_texture: TextureRect = $MaskTexture
@onready var progress_wheel: ColorRect = $ProgressWheel
@onready var hunger_bar: TextureRect = $HungerBar

var blur_effect_material:ShaderMaterial
var mask_effect_material:ShaderMaterial
var progress_material:ShaderMaterial
var hunger_prog_mat:ShaderMaterial



func _ready() -> void:
	z_index = GVar.LAYER_DICT[GVar.LAYERS.LOWER]
	if GVar.game_manager == null:
		while(GVar.game_manager == null):
			await get_tree().process_frame
	GVar.game_manager.signal_bus.mask_changed.connect(_player_mask_state_changed)
	GVar.game_manager.signal_bus.player_start_feed.connect(player_feed_wheel.bind(true))
	GVar.game_manager.signal_bus.player_fed.connect(player_feed_wheel.bind(false))
	GVar.game_manager.signal_bus.hunger_changed.connect(update_hunger_bar)
	blur_effect_material = blur_effect.material
	mask_effect_material = mask_texture.material
	progress_material = progress_wheel.material
	hunger_prog_mat = hunger_bar.material

func player_feed_wheel(state:bool):
	var mod_tween:Tween = create_tween()
	if !state:
		mod_tween.tween_property(progress_wheel,"modulate",Color(1.0,1.0,1.0,0.0),0.1)
		mod_tween.parallel().tween_method(prog_wheel,1.0,0.0,0.1)
		return
	mod_tween.tween_property(progress_wheel,"modulate",Color(1.0,1.0,1.0,0.8),0.1)
	mod_tween.parallel().tween_method(prog_wheel,0.0,1.0,2.0)

func update_hunger_bar(value:float):
	hunger_prog_mat.set_shader_parameter("progress",value)

func prog_wheel(_value:float):
	progress_material.set_shader_parameter("left_ratio",_value)
	progress_material.set_shader_parameter("right_ratio",_value)

func _player_mask_state_changed(state:GVar.MASK):
	var tween:Tween = create_tween()
	match state:
		GVar.MASK.MASK_ON:
			tween.tween_method(change_blur_amount,1.0,0.5,1.0)
			tween.parallel().tween_method(change_mask_amount,1.0,0.0,1.0)
		GVar.MASK.MASK_OFF:
			tween.tween_method(change_blur_amount,0.5,1.0,1.0)
			tween.parallel().tween_method(change_mask_amount,0.0,1.0,1.0)

func change_mask_amount(value:float):
	mask_effect_material.set_shader_parameter("direction",Vector2(value,0.0))
	mask_effect_material.set_shader_parameter("alpha",sin(value*PI))
	mask_texture.scale = Vector2(1.0,1.0) * (1.0 - value)
	mask_texture.position = Vector2(0.0,0.0) + (value * Vector2(1920.0,1080.0))

func change_blur_amount(value:float):
	blur_effect_material.set_shader_parameter("radius",value)
