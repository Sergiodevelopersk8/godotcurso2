extends PlayerState
class_name Walk_Player_State

# Frecuencia entre pasos en segundos para la caminata
var step_interval: float = 0.45 
var step_timer: float = 0.0

func enter(_msg:Dictionary =  {}) -> void:
	step_timer = 0.0

#--------- FUNCIONES PROPIAS -----------

## Gestiona las entradas y transiciones mientras el jugador camina.
func update(delta):
	
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

## Aplica la velocidad normal y el desplazamiento del jugador.
func physics_update(delta: float) -> void:
	player.velocity = player.velocity.lerp(player.direction * player.speed, player.accel * delta)
	player.move_and_slide()
	
	if player.direction != Vector3.ZERO and player.is_on_floor():
		step_timer += delta
		if step_timer >= step_interval:
			step_timer = 0.0
			# Usar has_method previene errores si la clase global no se ha recompilado en el editor
			if player.footstep_sound and player.footstep_sound.has_method("play_footstep"):
				player.footstep_sound.play_footstep()




## Anima el balanceo de la camara durante el desplazamiento.
func camera_bob(delta):
	player._delta += delta
	
	var cam_bob = floor(abs(player.direction.z) + abs(player.direction.x)) * player._delta * player.cam_Bob_Speed
	var objCam = player.origCamPos + Vector3.UP * sin(cam_bob) * player.cam_Bob_Up_Down
	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	
	if player._delta > 20:
		player._delta = 0
