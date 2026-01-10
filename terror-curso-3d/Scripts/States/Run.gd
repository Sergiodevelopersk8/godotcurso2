# res://Scripts/States/Run.gd
extends PlayerState
class_name Run

func enter(_msg = {}):
	pass

func update(delta):
	if player.process_input(delta) == Vector3.ZERO:
		state_machine.transition_to("Idle",{})
	
	
	if Input.is_action_just_released("action_run"):
		state_machine.transition_to("Walk",{})
	
	if !player.is_on_floor():
		state_machine.transition_to("Air",{})
	
	if Input.is_action_just_pressed("action_jump") and player.canJump:
		state_machine.transition_to("Air",{do_jump = true})
	camera_bob(delta)
	
	


func physics_update(delta: float) -> void:
	player.velocity = player.velocity.lerp(player.direction * player.speed * 1.5, player.accel * delta)
	player.move_and_slide()


func camera_bob(delta):
	player._delta += delta
	var cam_bob = floor(abs(player.direction.z) + abs(player.direction.x)) * player._delta * player.camBobSpeed
	var objCam = player.origCamPos + Vector3.UP * sin(cam_bob) * player.camBobUpDown * 1.5
	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	
	if player._delta > 20:
		player._delta = 0
