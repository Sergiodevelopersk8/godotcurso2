# Archivo: src/entities/player/states/Run.gd
# Descripci?n: Define el estado de correr del personaje.
# Este script forma parte de la l?gica principal del juego y ayuda a entender su comportamiento dentro de Godot.

# Hereda de PlayerState y reutiliza sus propiedades y comportamiento base.
extends PlayerState
# Registra Run_Player_State como nombre de clase global para usarlo en otros scripts.
class_name Run_Player_State

# Crea step_interval e inicializa su valor con 0.28.
var step_interval: float = 0.28 # Cadencia más rápida para correr
# Crea step_timer e inicializa su valor con 0.0.
var step_timer: float = 0.0

# Entra a este estado y prepara variables, animaciones o condiciones.
func enter(_msg: Dictionary = {}) -> void:
	# Reiniciamos el temporizador con el intervalo para que el primer paso suene de inmediato al empezar a correr
	step_timer = step_interval




#--------- FUNCIONES PROPIAS -----------
## Gestiona las entradas y transiciones mientras el jugador corre.
# Actualiza la l?gica del estado activo del personaje cada frame.
func update(delta: float) -> void:
	# Comprueba get_tree().paused; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if get_tree().paused:
		# Guarda en player.velocity el resultado de Vector3.ZERO.
		player.velocity = Vector3.ZERO
		# Termina el metodo sin devolver un valor.
		return

	# Comprueba player.process_input(delta) == Vector3.ZERO; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if player.process_input(delta) == Vector3.ZERO:
		# Llama al metodo state_machine.change_state para realizar esta accion en este punto.
		state_machine.change_state("Idle")
		# Termina el metodo sin devolver un valor.
		return
	
	# Comprueba Input.is_action_just_released("run"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if Input.is_action_just_released("run"):
		# Llama al metodo state_machine.change_state para realizar esta accion en este punto.
		state_machine.change_state("Walk")
		# Termina el metodo sin devolver un valor.
		return
		
	# Comprueba Input.is_action_pressed("action_crouch"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if Input.is_action_pressed("action_crouch"):
		# Llama al metodo state_machine.change_state para realizar esta accion en este punto.
		state_machine.change_state("Crouch")
		# Termina el metodo sin devolver un valor.
		return
		
	# Comprueba not player.is_on_floor(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not player.is_on_floor():
		# Llama al metodo state_machine.change_state para realizar esta accion en este punto.
		state_machine.change_state("Air")
		# Termina el metodo sin devolver un valor.
		return

	# Llama al metodo ManagerCamreaBob.camera_bob para realizar esta accion en este punto.
	ManagerCamreaBob.camera_bob(player,delta)

## Aplica la velocidad aumentada del estado de carrera.
# Aplica movimiento y f?sicas del estado actual del personaje.
func physics_update(delta: float) -> void:
	# Guarda en player.velocity el resultado de player.velocity.lerp(player.direction * player.run_speed, player.accel * delta).
	player.velocity = player.velocity.lerp(player.direction * player.run_speed, player.accel * delta)
	# Llama al metodo player.move_and_slide para realizar esta accion en este punto.
	player.move_and_slide()
	
	# Comprueba player.direction != Vector3.ZERO and player.is_on_floor(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if player.direction != Vector3.ZERO and player.is_on_floor():
		# Suma a step_timer el valor delta respecto de su valor anterior.
		step_timer += delta
		# Comprueba step_timer >= step_interval; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if step_timer >= step_interval:
			# Guarda en step_timer el resultado de 0.0.
			step_timer = 0.0
			# Comprueba player.footstep_sound is FootstepPlayer; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if player.footstep_sound is FootstepPlayer:
				# Llama al metodo player.footstep_sound.play_footstep para realizar esta accion en este punto.
				player.footstep_sound.play_footstep()

## Anima el balanceo de la camara durante la carrera.
