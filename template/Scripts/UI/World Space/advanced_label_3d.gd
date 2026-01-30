class_name AdvancedLabel3D
extends Label3D

@export var animation_speed : float = 0.3
@export var _font_size : int = 12
@export var _billboard : BaseMaterial3D.BillboardMode

func _ready() -> void:
	font_size = _font_size
	billboard = _billboard
	return

func _set_value(in_string : String ,color:Color = Color.WHITE) -> void:
	modulate = color
	text = in_string
	return

func _animate() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y + 2, animation_speed).set_trans(tween.TRANS_SINE)
	tween.chain()
	tween.tween_property(self, "modulate:a", 0, (animation_speed) / 3)
	tween.parallel().tween_property(self, "outline_modulate:a", 0, (animation_speed) / 3)
	await tween.finished
	tween.kill()
	await get_tree().create_timer(0.5).timeout
	queue_free()
	return
