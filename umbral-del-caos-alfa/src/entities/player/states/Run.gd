extends PlayerState
class_name Run_Player_State

var step_interval: float = 0.28 # Cadencia más rápida para correr
var step_timer: float = 0.0

func enter(_msg: Dictionary = {}) -> void:
	# Reiniciamos el temporizador con el intervalo para que el primer paso suene de inmediato al empezar a correr
	step_timer = step_interval




#--------- FUNCIONES PROPIAS -----------
## Gestiona las entradas y transiciones mientras el jugador corre.
func update(delta: float) -> void:
	if get_tree().paused:
		player.velocity = Vector3.ZERO
		return

	if player.process_input(delta) == Vector3.ZERO:
		state_machine.change_state("Idle")
		return
	
	if Input.is_action_just_released("run"):
		state_machine.change_state("Walk")
		return
		
	if Input.is_action_pressed("action_crouch"):
		state_machine.change_state("Crouch")
		return
		
	if not player.is_on_floor():
		state_machine.change_state("Air")
		return

	camera_bob(delta)

## Aplica la velocidad aumentada del estado de carrera.
func physics_update(delta: float) -> void:
	player.velocity = player.velocity.lerp(player.direction * player.run_speed, player.accel * delta)
	player.move_and_slide()
	
	if player.direction != Vector3.ZERO and player.is_on_floor():
		step_timer += delta
		if step_timer >= step_interval:
			step_timer = 0.0
			if player.footstep_sound is FootstepPlayer:
				player.footstep_sound.play_footstep()

## Anima el balanceo de la camara durante la carrera.
func camera_bob(delta):
	player._delta += delta
	var cam_bob = floor(abs(player.direction.z) + abs(player.direction.x)) * player._delta * player.cam_Bob_Speed
	var objCam = player.origCamPos + Vector3.UP * sin(cam_bob) * player.cam_Bob_Up_Down * 1.5
	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	
	if player._delta > 20:
		player._delta = 0
