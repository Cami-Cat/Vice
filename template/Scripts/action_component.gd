class_name ActionComponent extends Node3D

signal lclick_action_pressed
signal mask_action_pressed

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Mask_Action"):
		mask_action_pressed.emit()
	if Input.is_action_just_pressed("LClick_Action"):
		lclick_action_pressed.emit()
