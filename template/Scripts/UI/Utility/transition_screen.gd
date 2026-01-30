class_name TransitionScreen
extends ColorRect

signal screen_hidden()
signal screen_visible()

const SCREEN_TRANSITION_MATERIAL = preload("res://Scripts/Resources/Materials/screen_transition_material.tres")

@export var transition_color:Color = Color.WHITE
var speed:float = 0.5

var mat:ShaderMaterial

func _init() -> void:
	material = SCREEN_TRANSITION_MATERIAL.duplicate()
	mat = material

func _ready() -> void:
	mat.set_shader_parameter("color",transition_color)
func transition_screen(state:bool):
	mat.set_shader_parameter("fill",state)
	var tween = create_tween()
	set_material_progress(0.0)
	if state:
		tween.tween_method(set_material_progress,0.0,1.0,speed)
		await tween.finished
		screen_hidden.emit()
	elif !state:
		tween.tween_method(set_material_progress,0.0,1.0,speed)
		await tween.finished
		screen_visible.emit()

func set_material_progress(value:float):
	mat.set_shader_parameter("progress",value)
