# res://Scripts/States/Walk.gd
extends PlayerState
class_name Walk


func update(delta):
	if player.process_input(delta) == Vector3.ZERO:
		state_machine.transition_to("Idle",{})
		
	player._delta += delta
	
	var cam_bob = floor(abs(player.direction.z) + abs(player.direction.x)) * player._delta * player.camBobSpeed
	var objCam = player.origCamPos + Vector3.UP * sin(cam_bob) * player.camBobUpDown
	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	
	if player._delta > 20:
		player._delta = 0
	
	

func physics_update(delta: float) -> void:
	player.velocity = player.velocity.lerp(player.direction * player.speed, player.accel * delta)
	player.move_and_slide()
	
