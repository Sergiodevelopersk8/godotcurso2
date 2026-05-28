extends PlayerState
class_name Idle_Player_State


#--------- FUNCIONES DEL SISTEMA -----------



#--------- FUNCIONES PROPIAS -----------
func update(delta):
	player._delta += delta
	#EFECTO DE LA CAMARA QUE SIMULA QUE SE
	#MUEVA CUANDO EL PLAYER CAMINA 
	var cam_bob = floor(abs(1) + abs(1)) * player._delta * 1
	var objCam = player.origCamPos + Vector3.UP * sin(cam_bob) * .05
	
	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	if player._delta > 20:
		player._delta = 0

func physics_update(delta: float) -> void:
	
	#cambi de estado para moverte
	if player.process_input(delta) != Vector3.ZERO:
		state_machine.change_state("Walk")
		return
	
	#cambio de estado para estar agachado
	if Input.is_action_just_pressed("action_crouch"):
		state_machine.change_state("Crouch")
	
	if !player.is_on_floor():
		state_machine.change_state("Air")
		
	
	
	player.velocity = player.velocity.lerp(Vector3.ZERO,player.friction * delta)
	
	player.move_and_slide()
	
	
