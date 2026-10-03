# Archivo: src/entities/player/states/Idle.gd
# Descripci?n: Define el estado inactivo del personaje cuando no se est? moviendo.
# Este script forma parte de la l?gica principal del juego y ayuda a entender su comportamiento dentro de Godot.

# Hereda de PlayerState y reutiliza sus propiedades y comportamiento base.
extends PlayerState
# Registra Idle_Player_State como nombre de clase global para usarlo en otros scripts.
class_name Idle_Player_State


#--------- FUNCIONES PROPIAS -----------
## Actualiza el balanceo suave de la camara cuando el jugador esta quieto.
# Actualiza la l?gica del estado activo del personaje cada frame.
func update(delta):
	# Suma a player._delta el valor delta respecto de su valor anterior.
	player._delta += delta
	#EFECTO DE LA CAMARA QUE SIMULA QUE SE
	#MUEVA CUANDO EL PLAYER CAMINA 
	var cam_bob = floor(abs(1) + abs(1)) * player._delta * 1
	# Crea objCam e inicializa su valor con player.origCamPos + Vector3.UP * sin(cam_bob) * .05.
	var objCam = player.origCamPos + Vector3.UP * sin(cam_bob) * .05
	
	# Guarda en player.camera_3d.position el resultado de player.camera_3d.position.lerp(objCam, delta).
	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	# Comprueba player._delta > 20; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if player._delta > 20:
		# Guarda en player._delta el resultado de 0.
		player._delta = 0

## Comprueba cambios de estado y mantiene al jugador detenido en el suelo.
# Aplica movimiento y f?sicas del estado actual del personaje.
func physics_update(delta: float) -> void:
	
	#cambi de estado para moverte
	if player.process_input(delta) != Vector3.ZERO:
		# Llama al metodo state_machine.change_state para realizar esta accion en este punto.
		state_machine.change_state("Walk")
		# Termina el metodo sin devolver un valor.
		return
	
	#cambio de estado para estar agachado
	if Input.is_action_just_pressed("action_crouch"):
		# Llama al metodo state_machine.change_state para realizar esta accion en este punto.
		state_machine.change_state("Crouch")
	
	# Comprueba !player.is_on_floor(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if !player.is_on_floor():
		# Llama al metodo state_machine.change_state para realizar esta accion en este punto.
		state_machine.change_state("Air")
		
	
	# Guarda en player.velocity el resultado de player.velocity.lerp(Vector3.ZERO,player.friction * delta).
	player.velocity = player.velocity.lerp(Vector3.ZERO,player.friction * delta)
	
	# Llama al metodo player.move_and_slide para realizar esta accion en este punto.
	player.move_and_slide()
	
	
