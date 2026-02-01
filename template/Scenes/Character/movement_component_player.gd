class_name MovementComponentPlayer extends MovementComponent


func _get_camera_basis() -> Basis:
	return pawn.find_child("CameraTargetComponent").basis

func _physics_process(delta: float) -> void:
	if !pawn.is_on_floor():
		pawn.velocity.y -= (gravity / 100.0) * delta
	if disabled: return
	var input_direction = Input.get_vector("Strafe_Left", "Strafe_Right", "Walk_Forward", "Walk_Backward")
	input_direction = input_direction.normalized()
	var sprint_input = Input.is_action_pressed("Sprint_Action")
	var direction = (_get_camera_basis() * Vector3(input_direction.x, 0.0, input_direction.y)).normalized()
	if input_direction.x == 0.0:
		pawn.velocity.x = 0.0
	if input_direction.y == 0.0:
		pawn.velocity.z = 0.0
	
	if direction:
		if sprint_input:
			pawn.velocity.x = direction.x * max_run_speed * delta
			pawn.velocity.z = direction.z * max_run_speed * delta
		else:
			pawn.velocity.x = direction.x * max_walk_speed * delta
			pawn.velocity.z = direction.z * max_walk_speed * delta

	pawn.move_and_slide()
