extends PlayerState
class_name Run_Player_State

#--------- FUNCIONES PROPIAS -----------
func update(delta):
	if player.process_input(delta) == Vector3.ZERO:
		state_machine.change_state("Idle")
	
	if Input.is_action_just_released("run"):
		state_machine.change_state("Walk")
	
	camera_bob(delta)

func physics_update(delta: float) -> void:
	player.velocity = player.velocity.lerp(player.direction * player.speed * 1.5, player.accel * delta)
	player.move_and_slide()


func camera_bob(delta):
	player._delta += delta
	var cam_bob = floor(abs(player.direction.z) + abs(player.direction.x)) * player._delta * player.cam_Bob_Speed
	var objCam = player.origCamPos + Vector3.UP * sin(cam_bob) * player.cam_Bob_Up_Down * 1.5
	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	
	if player._delta > 20:
		player._delta = 0
