# Archivo: src/entities/player/states/Air.gd
# Descripci?n: Define el estado de salto o ca?da del personaje en el aire.
# Este script forma parte de la l?gica principal del juego y ayuda a entender su comportamiento dentro de Godot.

# Hereda de PlayerState y reutiliza sus propiedades y comportamiento base.
extends PlayerState
# Registra Air_Player_State como nombre de clase global para usarlo en otros scripts.
class_name Air_Player_State

## Cambia al estado Idle cuando el jugador vuelve a tocar el suelo.
# Actualiza la l?gica del estado activo del personaje cada frame.
func update(_delta: float) -> void:
	# Comprueba player.is_on_floor(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if player.is_on_floor():
		# Llama al metodo state_machine.change_state para realizar esta accion en este punto.
		state_machine.change_state("Idle") 


## Aplica el movimiento aereo, la gravedad y el desplazamiento del jugador.
# Aplica movimiento y f?sicas del estado actual del personaje.
func physics_update(delta: float) -> void:
	# Comprueba not player.process_input(delta) == Vector3.ZERO; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not player.process_input(delta) == Vector3.ZERO:
		# Guarda en player.velocity el resultado de lerp(player.velocity, player.process_input(delta) * player.speed, player.ACCEL_AIR * delta).
		player.velocity =  lerp(player.velocity, player.process_input(delta) * player.speed, player.ACCEL_AIR * delta)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Guarda en player.velocity el resultado de lerp(player.velocity, Vector3.ZERO, player.ACCEL_AIR * delta).
		player.velocity = lerp(player.velocity, Vector3.ZERO, player.ACCEL_AIR * delta)
	
	# Resta de player.velocity.y el valor player.gravity * delta respecto de su valor anterior.
	player.velocity.y -= player.gravity * delta
	# Llama al metodo player.move_and_slide para realizar esta accion en este punto.
	player.move_and_slide()
