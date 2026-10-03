# res://assets/models/Player/States/in_dialogue.gd
extends PlayerState

# Define DIALOGUE_BOB_SPEED con el valor fijo 0.8.
const DIALOGUE_BOB_SPEED := 0.8   # más lento que caminar, se siente como respiración
# Define DIALOGUE_BOB_HEIGHT con el valor fijo 0.03.
const DIALOGUE_BOB_HEIGHT := 0.03 # sutil, no queremos que distraiga del diálogo


# Entra a este estado y prepara variables, animaciones o condiciones.
func enter(_msg := {}) -> void:
	# Guarda en can_rotate_camera el resultado de false.
	can_rotate_camera = false
	# Guarda en can_move el resultado de false.
	can_move = false

	# Comprueba player; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if player:
		# Guarda en player.direction el resultado de Vector3.ZERO.
		player.direction = Vector3.ZERO
		# Guarda en player.velocity el resultado de Vector3.ZERO.
		player.velocity = Vector3.ZERO
		# Comprueba player.ray_cast_interactuar; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if player.ray_cast_interactuar:
			# Guarda en player.ray_cast_interactuar.enabled el resultado de false.
			player.ray_cast_interactuar.enabled = false

	# Llama al metodo Input.set_mouse_mode para realizar esta accion en este punto.
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Sale del estado actual y limpia recursos o flags asociados.
func exit() -> void:
	# Comprueba player and player.ray_cast_interactuar; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if player and player.ray_cast_interactuar:
		# Guarda en player.ray_cast_interactuar.enabled el resultado de true.
		player.ray_cast_interactuar.enabled = true
	
	# Llama al metodo Input.set_mouse_mode para realizar esta accion en este punto.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Actualiza la l?gica del estado activo del personaje cada frame.
func update(_delta: float) -> void:
	# Llama al metodo ManagerCamreaBob.camera_bob_dialogue para realizar esta accion en este punto.
	ManagerCamreaBob.camera_bob_dialogue(player,_delta)
	

# Aplica movimiento y f?sicas del estado actual del personaje.
func physics_update(delta: float) -> void:
	# Guarda en player.velocity.x el resultado de move_toward(player.velocity.x, 0, player.friction * delta).
	player.velocity.x = move_toward(player.velocity.x, 0, player.friction * delta)
	# Guarda en player.velocity.z el resultado de move_toward(player.velocity.z, 0, player.friction * delta).
	player.velocity.z = move_toward(player.velocity.z, 0, player.friction * delta)
	# Resta de player.velocity.y el valor player.gravity * delta respecto de su valor anterior.
	player.velocity.y -= player.gravity * delta
	# Llama al metodo player.move_and_slide para realizar esta accion en este punto.
	player.move_and_slide()
