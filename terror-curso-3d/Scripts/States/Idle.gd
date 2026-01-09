# res://Scripts/States/Idle.gd
extends PlayerState
class_name Idle


func update(delta):
	player._delta += delta
	var cam_bob = floor(abs(1) + abs(1)) * player._delta * 1
	var objCam = player.origCamPos + Vector3.UP * sin(cam_bob) * .05
	
	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	if player._delta > 20:
		player._delta = 0

func physics_update(delta: float) -> void:
	
	if player.process_input(delta) != Vector3.ZERO:
		state_machine.transition_to("Walk",{})
		return
	
	if Input.is_action_just_pressed("action_crouch"):
		state_machine.transition_to("Crouch",{})
	
	
	player.velocity = player.velocity.lerp(Vector3.ZERO, player.friction * delta)
	player.move_and_slide()
	
	
