extends PlayerState
class_name Walk_Player_State


#--------- FUNCIONES PROPIAS -----------

func update(delta):
	
	#if Global.is_dialogue_active:
	#	state_machine.change_state("Idle")
	#	return
	if get_tree().paused:
		player.velocity = Vector3.ZERO
		return
	
	if player.process_input(delta) == Vector3.ZERO:
		state_machine.change_state("Idle")
	camera_bob(delta)
	
	if Input.is_action_pressed("run"):
		state_machine.change_state("Run")
	if Input.is_action_pressed("action_crouch"):
		state_machine.change_state("Crouch")
	if !player.is_on_floor():
		state_machine.change_state("Air")

func physics_update(delta: float) -> void:
	player.velocity = player.velocity.lerp(player.direction * player.speed, player.accel * delta)
	player.move_and_slide()
	


func camera_bob(delta):
	player._delta += delta
	
	var cam_bob = floor(abs(player.direction.z) + abs(player.direction.x)) * player._delta * player.cam_Bob_Speed
	var objCam = player.origCamPos + Vector3.UP * sin(cam_bob) * player.cam_Bob_Up_Down
	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	
	if player._delta > 20:
		player._delta = 0
