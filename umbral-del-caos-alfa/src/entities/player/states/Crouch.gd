# Archivo: src/entities/player/states/Crouch.gd
# Descripci?n: Define el estado de agacharse del personaje y sus restricciones de movimiento.
# Este script forma parte de la l?gica principal del juego y ayuda a entender su comportamiento dentro de Godot.

# Hereda de PlayerState y reutiliza sus propiedades y comportamiento base.
extends PlayerState
# Registra Crouch_Player_State como nombre de clase global para usarlo en otros scripts.
class_name Crouch_Player_State

#------------VARIABLES----------

# Obtiene la referencia raycast_crouch cuando el nodo ya esta listo.
@onready var raycast_crouch: RayCast3D = $"../../Raycasts/RaycastCrouch"
# Obtiene la referencia camera_3d cuando el nodo ya esta listo.
@onready var camera_3d: Camera3D = $"../../Camera3D"
# Obtiene la referencia pcap cuando el nodo ya esta listo.
@onready var pcap: CollisionShape3D = $"../../CollisionShape3D"

# Crea has_crouch e inicializa su valor con false.
var has_crouch := false
# Crea crouch_speed e inicializa su valor con 20.
var crouch_speed := 20

# Define HEIGHT_NORMAL con el valor fijo 2.5.
const HEIGHT_NORMAL = 2.5
# Define HEIGHT_CROUCH con el valor fijo 1.5.
const HEIGHT_CROUCH = 1.5
# Define CAM_NORMAL con el valor fijo 1.0.
const CAM_NORMAL = 1.0
# Define CAM_CROUCH con el valor fijo 0.3.
const CAM_CROUCH = 0.3

#------------FUNCIONE PROPIAS----------

## Inicializa el estado agachado al entrar en el estado.
# Entra a este estado y prepara variables, animaciones o condiciones.
func enter(_msg := {}) -> void:
	# Guarda en has_crouch el resultado de false.
	has_crouch = false
	# No ejecuta ninguna accion; deja este bloque vacio intencionalmente.
	pass

## Ajusta suavemente la altura, la camara y las transiciones del jugador agachado.
# Actualiza la l?gica del estado activo del personaje cada frame.
func update(delta: float):
	# Comprueba get_tree().paused; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if get_tree().paused:
		# Guarda en player.velocity el resultado de Vector3.ZERO.
		player.velocity = Vector3.ZERO
		# Termina el metodo sin devolver un valor.
		return
	# (Agachado o Levantado)
	var lerp_speed = 10.0 * delta # Una velocidad constante y suave
	
	# Comprueba Input.is_action_pressed("action_crouch"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if Input.is_action_pressed("action_crouch"):
		# Se agacha
		pcap.shape.height = lerp(pcap.shape.height, HEIGHT_CROUCH, lerp_speed)
		# Guarda en camera_3d.position.y el resultado de lerp(camera_3d.position.y, CAM_CROUCH, lerp_speed).
		camera_3d.position.y = lerp(camera_3d.position.y, CAM_CROUCH, lerp_speed)
	# Comprueba !raycast_crouch.is_colliding() si las condiciones anteriores resultaron falsas.
	elif !raycast_crouch.is_colliding():
		# Se levanta (solo si no hay nada en la cabeza)
		pcap.shape.height = lerp(pcap.shape.height, HEIGHT_NORMAL, lerp_speed)
		# Guarda en camera_3d.position.y el resultado de lerp(camera_3d.position.y, CAM_NORMAL, lerp_speed).
		camera_3d.position.y = lerp(camera_3d.position.y, CAM_NORMAL, lerp_speed)
		
		# Si ya está casi estirado, vuelve a Idle
		if pcap.shape.height > 2.4:
			# Llama al metodo state_machine.change_state para realizar esta accion en este punto.
			state_machine.change_state("Idle")

	# 2. CAMBIO A AIRE (Si cae de una plataforma)
	if !player.is_on_floor():
		# Llama al metodo state_machine.change_state para realizar esta accion en este punto.
		state_machine.change_state("Air")
#	ManagerCamreaBob.camera_bob(player,delta)

## Anima el balanceo vertical de la camara mientras el jugador esta agachado.
# Genera un ligero movimiento de c?mara para reforzar la sensaci?n de caminar o hablar.
func camera_bob(delta):
	# Suma a player._delta el valor delta respecto de su valor anterior.
	player._delta += delta
	# Crea cam_bob e inicializa su valor con floor(abs(player.direction.z) + abs(player.direction.x)) * player._delta * player.cam_Bob_Speed.
	var cam_bob = floor(abs(player.direction.z) + abs(player.direction.x)) * player._delta * player.cam_Bob_Speed
	# Crea objCam e inicializa su valor con player.origCamPos + Vector3.UP * sin(cam_bob) * player.cam_Bob_Up_Down * 1.5.
	var objCam = player.origCamPos + Vector3.UP * sin(cam_bob) * player.cam_Bob_Up_Down * 1.5
	# Guarda en player.camera_3d.position el resultado de player.camera_3d.position.lerp(objCam, delta).
	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	
	# Comprueba player._delta > 20; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if player._delta > 20:
		# Guarda en player._delta el resultado de 0.
		player._delta = 0


## Aplica el movimiento reducido y la gravedad del estado agachado.
# Aplica movimiento y f?sicas del estado actual del personaje.
func physics_update(delta: float):
	
	# Llama al metodo player.process_input para realizar esta accion en este punto.
	player.process_input(delta)
	
	# Movimiento  lento al estar agachado
	var target_vel = player.direction * (player.speed * 0.4)
	# Guarda en player.velocity.x el resultado de lerp(player.velocity.x, target_vel.x, player.accel * delta).
	player.velocity.x = lerp(player.velocity.x, target_vel.x, player.accel * delta)
	# Guarda en player.velocity.z el resultado de lerp(player.velocity.z, target_vel.z, player.accel * delta).
	player.velocity.z = lerp(player.velocity.z, target_vel.z, player.accel * delta)
	
	# Gravedad 
	player.velocity.y -= player.gravity * delta
	# Llama al metodo player.move_and_slide para realizar esta accion en este punto.
	player.move_and_slide()
