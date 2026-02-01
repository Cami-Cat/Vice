extends TextureRect

const T_CROSSHAIR_LURE_NEUTRAL = preload("uid://dc5vlct51m3dv")
const T_CROSSHAIR_LURE_VALID = preload("uid://dglk1cn8qnrjk")
const T_CROSSHAIR_TEETH_NEUTRAL = preload("uid://dk6vr1t0gm0gs")
const T_CROSSHAIR_TEETH_OPEN = preload("uid://5ti5n2qq3123")

var mask_on:bool = true

func _ready() -> void:
	await get_tree().process_frame
	GVar.player_context_raycast.hovered_pawn_changed.connect(_change_crosshair)
	GVar.signal_bus.mask_changed.connect(set_mask_on)

func set_mask_on(state:GVar.MASK):
	match state:
		GVar.MASK.MASK_ON:
			mask_on = true
		GVar.MASK.MASK_OFF:
			mask_on = false
	if !is_instance_valid(GVar.player_context_raycast.hovered_pawn) : 
		_change_crosshair(null)
		return
	_change_crosshair(GVar.player_context_raycast.hovered_pawn)

func _change_crosshair(pawn:Pawn):
	if pawn:
		if mask_on:
			texture = T_CROSSHAIR_LURE_VALID
		else:
			texture = T_CROSSHAIR_TEETH_OPEN
	else:
		if mask_on:
			texture = T_CROSSHAIR_LURE_NEUTRAL
		else:
			texture = T_CROSSHAIR_TEETH_NEUTRAL
	pass
