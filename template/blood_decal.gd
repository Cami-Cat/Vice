class_name BloodDecal extends Node3D

@onready var decal: Decal = $Decal

const _1_1 = preload("res://Assets/Sprites/Blood/1_1.png")
const _1_6 = preload("res://Assets/Sprites/Blood/1_6.png")
const _1_9 = preload("res://Assets/Sprites/Blood/1_9.png")
const _1_13 = preload("res://Assets/Sprites/Blood/1_13.png")

const BLOOD_ARRAY:Array = [_1_1,_1_6,_1_9,_1_13]

func _ready() -> void:
	rotate(Vector3.UP,randf_range(0.0,2.0*PI))
	scale = scale * randf_range(2.0,3.0)
	decal.texture_albedo = BLOOD_ARRAY.pick_random()
