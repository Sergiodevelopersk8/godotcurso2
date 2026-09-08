# res://assets/models/Player/footstep_sound.gd
extends AudioStreamPlayer
class_name FootstepPlayer

@export var player: Player
@export var ground_raycast: RayCast3D

const DEFAULT_FOOTSTEP = preload("res://assets/audio/SFX/footsteps/boots/0.ogg")

const FOOTSTEP_AUDIO_MAP = {
	"Grass": preload("res://assets/audio/SFX/footsteps/grass/0.ogg"),
	"Metal": preload("res://assets/audio/SFX/footsteps/metal/0.ogg"),
	"Concrete": preload("res://assets/audio/SFX/footsteps/wood/0.ogg"),
	"Terrazzo": preload("res://assets/audio/SFX/footsteps/wood/0.ogg")
}

func play_footstep() -> void:
	if not player or not player.is_on_floor():
		return
		
	var selected_stream: AudioStream = DEFAULT_FOOTSTEP
	
	if ground_raycast and ground_raycast.is_colliding():
		var collider = ground_raycast.get_collider()
		if collider:
			var ground_mesh = collider.get_parent()
			if ground_mesh is MeshInstance3D and ground_mesh.get_active_material(0) != null:
				var mat_path = ground_mesh.get_active_material(0).resource_path
				for key in FOOTSTEP_AUDIO_MAP.keys():
					if key in mat_path:
						selected_stream = FOOTSTEP_AUDIO_MAP[key]
						break

	stream = selected_stream
	pitch_scale = randf_range(0.8, 1.2)
	play()
