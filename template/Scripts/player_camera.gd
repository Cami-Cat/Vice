class_name PlayerCamera3D
extends Camera3D

@onready var camera_target : Node3D = null
@onready var starting_fov:float = fov
@export var period = 0.3
@export var magnitude = 0.4
var camera_speed : float = 2.0 # units

var camera_rotate : bool = false
var camera_rotation_speed : float = 1.5

func _init() -> void:
	return

func _ready() -> void:
	if GVar.game_manager == null:
		while(GVar.game_manager == null):
			await get_tree().process_frame
	GVar.signal_bus.mask_changed.connect(mask_changed)
	GVar.signal_bus.pawn_died.connect(shake_shake_shake)
	return

func shake_shake_shake():
	var initial_transform = self.transform 
	var elapsed_time = 0.0

	while elapsed_time < period:
		var offset = Vector3(
			randf_range(-magnitude, magnitude),
			randf_range(-magnitude, magnitude),
			0.0
		)

		self.transform.origin = initial_transform.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	self.transform = initial_transform

func mask_changed(state:GVar.MASK):
	var tween:Tween = create_tween()
	match state:
		GVar.MASK.MASK_ON:
			tween.tween_property(self,"fov",starting_fov,1.0)
		GVar.MASK.MASK_OFF:
			tween.tween_property(self,"fov",starting_fov*1.5,1.0)

func _menu_rotate(do : bool = false) -> void:
	camera_rotate = do
	return

func _process(delta: float) -> void:
	if camera_rotate:
		rotation_degrees.y += camera_rotation_speed * delta
	return

func set_target(in_target : Node3D) -> void:
	camera_target = in_target
	return
