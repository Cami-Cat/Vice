extends Node3D

@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D

func _ready() -> void:
	cpu_particles_3d.emitting = true
	await cpu_particles_3d.finished
	queue_free()
