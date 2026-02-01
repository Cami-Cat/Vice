class_name UiMain
extends Control

@onready var blur_effect: ColorRect = $BlurEffect
@onready var control: Control = $Control
@onready var mask_texture: TextureRect = $MaskTexture

var blur_effect_material:ShaderMaterial
var mask_effect_material:ShaderMaterial

func _ready() -> void:
	z_index = GVar.LAYER_DICT[GVar.LAYERS.LOWER]
	if GVar.game_manager == null:
		while(GVar.game_manager == null):
			await get_tree().process_frame
	GVar.game_manager.signal_bus.mask_changed.connect(_player_mask_state_changed)
	blur_effect_material = blur_effect.material
	mask_effect_material = mask_texture.material

func _player_mask_state_changed(state:GVar.MASK):
	var tween:Tween = create_tween()
	match state:
		GVar.MASK.MASK_ON:
			tween.tween_method(change_blur_amount,1.0,4.0,1.0)
			tween.parallel().tween_method(change_mask_amount,1.0,0.0,1.0)
		GVar.MASK.MASK_OFF:
			tween.tween_method(change_blur_amount,4.0,1.0,1.0)
			tween.parallel().tween_method(change_mask_amount,0.0,1.0,1.0)

func change_mask_amount(value:float):

	mask_effect_material.set_shader_parameter("direction",Vector2(value,0.0))
	mask_effect_material.set_shader_parameter("alpha",sin(value*PI))
	mask_texture.scale = Vector2(1.0,1.0) * (1.0 - value)
	mask_texture.position = Vector2(0.0,0.0) + (value * Vector2(1920.0,1080.0))

func change_blur_amount(value:float):
	blur_effect_material.set_shader_parameter("blur_amount",value)
