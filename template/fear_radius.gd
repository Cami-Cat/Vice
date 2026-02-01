class_name FearRadius
extends Node3D

func _init() -> void:
	name = "FearRadius"
	_construct_area()
	return

func _construct_area() -> void:
	var area = Area3D.new()
	add_child(area)
	var shape = CollisionShape3D.new()
	area.add_child(shape)
	shape.shape = SphereShape3D.new() as SphereShape3D
	shape.shape.radius = 10.0
	area.body_entered.connect(_fear)
	area.body_exited.connect(_unfear)
	return

func _fear(in_body : Node3D) -> void:
	if in_body is Pawn:
		if is_instance_valid(in_body.pawn_ai):
			in_body.pawn_ai._alert(true)
	return

func _unfear(in_body : Node3D) -> void:
	if in_body is Pawn:
		if is_instance_valid(in_body.pawn_ai):
			in_body.pawn_ai._alert(false)
	return
