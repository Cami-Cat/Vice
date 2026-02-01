class_name ContextRayCast3D extends RayCast3D

signal hovered_pawn_changed(pawn:Pawn)

var hovered_pawn:Pawn = null: 
	set(value):
		hovered_pawn = value
		hovered_pawn_changed.emit(hovered_pawn)

func _init() -> void:
	target_position = Vector3(0.0,0.0,-5.0)
	set_collision_mask_value(2, true)

func _ready() -> void:
	GVar.player_context_raycast = self

func _physics_process(_delta: float) -> void:
	if is_colliding():
		var col = get_collider()
		if col is Pawn:
			if hovered_pawn != col:
				hovered_pawn = col
	else:
		if hovered_pawn != null:
			hovered_pawn = null
