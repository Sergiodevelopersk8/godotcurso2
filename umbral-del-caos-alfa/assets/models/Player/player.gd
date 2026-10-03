#res://assets/models/Player/player.gd
extends CharacterBody3D
# Registra Player como nombre de clase global para usarlo en otros scripts.
class_name Player


#-------onreadys camara----------
@onready var camera_3d: Camera3D = $Camera3D
# Obtiene la referencia origCamPos cuando el nodo ya esta listo.
@onready var origCamPos : Vector3 = camera_3d.position
# Obtiene la referencia footstep_sound cuando el nodo ya esta listo.
@onready var footstep_sound: FootstepPlayer = $FootstepSound
# Obtiene la referencia ray_cast_interactuar cuando el nodo ya esta listo.
@onready var ray_cast_interactuar: Interactor3D = $Camera3D/RayCastInteractuar
# Expone fp_camera en el Inspector para configurarlo desde la escena.
@export var fp_camera: Camera3D
# Expone debug_camera en el Inspector para configurarlo desde la escena.
@export var debug_camera: Camera3D




#-------onreadys state_machines----------
@onready var state_machine: StateMachine = $StateMachine


#-------onreadys raycast camera ----------
@onready var ray_cast_ground_detector: RayCast3D = $Raycasts/RayCastGroundDetector
# Obtiene la referencia raycast_crouch cuando el nodo ya esta listo.
@onready var raycast_crouch: RayCast3D = $Raycasts/RaycastCrouch
# Obtiene la referencia hand cuando el nodo ya esta listo.
@onready var hand: Marker3D = $Camera3D/hand



#----------VARIABLES CAMARA---------
var move_and_rotate_player := true #sirve para habilitar si se mueve la camara o no
# Crea mouse_sens e inicializa su valor con 0.25.
var mouse_sens = 0.25 #sensibilidad con la que rota la camara
# Crea friction e inicializa su valor con 20.
var friction := 20 #AL DETENERSE
# Crea direction e inicializa su valor con Vector3().
var direction := Vector3()

# --------- VARIABLES DE VELOCIDADES, GRAVEDAD Y MOVIMIENTO_DE_CAMARA -----------
var speed := 3    # Velocidad normal de caminata
# Crea run_speed e inicializa su valor con 6.0.
var run_speed := 6.0   # Velocidad al correr (Añadir esta línea)
# Crea accel e inicializa su valor con 5.
var accel := 5      # Aceleración



#--------- VARIABLES DE VELOCIDADES, GRAVEDAD Y MOVIMIENTO_DE_CAMARA -----------
var jump_Force = 20
# Crea ACCEL_AIR e inicializa su valor con 5.
var ACCEL_AIR = 5
# Define gravity con el valor fijo 50.
const gravity = 50
# Crea joystick_deadzone e inicializa su valor con 0.2.
var joystick_deadzone = 0.2 #saber si el jostic se mueve 
# Crea controller_sensitivity e inicializa su valor con .05.
var controller_sensitivity = .05 #sensibilidad del control
# Crea cam_Bob_Speed e inicializa su valor con 5.
var cam_Bob_Speed := 5 #que tan rapido se mueve la camara
# Crea cam_Bob_Up_Down e inicializa su valor con 1.
var cam_Bob_Up_Down := 1 #cuanto se mueve de arriba y abajo
# Crea _delta e inicializa su valor con 0.
var _delta = 0
# Crea distance_foot_step e inicializa su valor con 0.0.
var distance_foot_step = 0.0
# Crea play_foot_step e inicializa su valor con 1.
var play_foot_step := 1




#--------- SEÑALES -----------
signal interactable_focused(description: String)



#--------- FUNCIONES DEL SISTEMA -----------


# Inicializa referencias, conexiones y estado inicial del nodo al arrancar.
func _ready() -> void:
	
	# Llama al metodo Input.set_mouse_mode para realizar esta accion en este punto.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

# Actualiza la l?gica del frame actual.
func _process(delta: float) -> void:
	# Llama la función directamente sin depender de move_and_rotate_player
	rotate_camera_joystick(delta)
		
	# Comprueba direction == Vector3.ZERO; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if direction == Vector3.ZERO:
		# Guarda en camera_3d.position el resultado de camera_3d.position.lerp(origCamPos, delta * 5).
		camera_3d.position = camera_3d.position.lerp(origCamPos, delta * 5)
		
	# Llama al metodo see_mouse para realizar esta accion en este punto.
	see_mouse()

# Fragmento de Player.gd corregido en _input

# Lee eventos del teclado y del rat?n para responder a acciones del jugador.
func _input(event: InputEvent) -> void:
	# Crea can_rotate e inicializa su valor con true.
	var can_rotate := true
	# Comprueba state_machine and state_machine.current_state; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if state_machine and state_machine.current_state:
		# Guarda en can_rotate el resultado de state_machine.current_state.can_rotate_camera.
		can_rotate = state_machine.current_state.can_rotate_camera

	# Comprueba event is InputEventMouseMotion and can_rotate; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if event is InputEventMouseMotion and can_rotate:
		# Llama al metodo rotate_camera para realizar esta accion en este punto.
		rotate_camera(event)

	# Comprueba Input.is_action_just_pressed("tree_person"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if Input.is_action_just_pressed("tree_person"):
		# Guarda en debug_camera.current el resultado de true.
		debug_camera.current = true
	# Comprueba Input.is_action_just_pressed("first_person"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if Input.is_action_just_pressed("first_person"):
		# Guarda en debug_camera.current el resultado de false.
		debug_camera.current = false


# Lee la entrada del jugador y calcula la direcci?n del movimiento.
func process_input(delta: float) -> Vector3:
	# Le pasamos 'self' (el jugador) y 'delta' (el delta frame real) al Manager
	ManagerCamreaBob.camera_bob(self, delta)
	
	# Guarda en direction el resultado de Vector3.ZERO.
	direction = Vector3.ZERO
	# Si el estado actual no permite moverse, no leemos input
	if state_machine and state_machine.current_state and not state_machine.current_state.can_move:
		# Termina el metodo y devuelve direction a quien lo llamo.
		return direction

	# Crea h_rot e inicializa su valor con global_transform.basis.get_euler().y.
	var h_rot = global_transform.basis.get_euler().y
	# Crea forward_input e inicializa su valor con Input.get_action_strength("down") - Input.get_action_strength("up").
	var forward_input = Input.get_action_strength("down") - Input.get_action_strength("up")
	# Crea side_input e inicializa su valor con Input.get_action_strength("right") - Input.get_action_strength("left").
	var side_input = Input.get_action_strength("right") - Input.get_action_strength("left")

	# Guarda en direction el resultado de Vector3(side_input, 0, forward_input).rotated(Vector3.UP, h_rot).normalized().
	direction = Vector3(side_input, 0, forward_input).rotated(Vector3.UP, h_rot).normalized()
	# Termina el metodo y devuelve direction a quien lo llamo.
	return direction

#--------- FUNCIONES PROPIAS -----------


# Rota la c?mara siguiendo el movimiento del rat?n.
func rotate_camera(event: InputEventMouseMotion) -> void:
	# Llama al metodo rotate_y para realizar esta accion en este punto.
	rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
	# Llama al metodo camera_3d.rotate_x para realizar esta accion en este punto.
	camera_3d.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
	# Guarda en camera_3d.rotation.x el resultado de clamp(camera_3d.rotation.x, deg_to_rad(-89), deg_to_rad(89)).
	camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-89), deg_to_rad(89))


# Fragmento para rotate_camera_joystick en Player.gd
# Rota la c?mara usando el stick del mando o del gamepad.
func rotate_camera_joystick(delta: float) -> void:
	# Crea joystick_vector e inicializa su valor con Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down", joystick_deadzone).
	var joystick_vector := Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down", joystick_deadzone)
	
	# Ponemos el print AQUÍ ARRIBA antes de cualquier 'if' o 'return'
	if joystick_vector != Vector2.ZERO:
		# Llama al metodo print para realizar esta accion en este punto.
		print("Vector Joystick detectado: ", joystick_vector)

	# Verificación del estado
	if state_machine and state_machine.current_state:
		# Comprueba not state_machine.current_state.can_rotate_camera; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if not state_machine.current_state.can_rotate_camera:
			# Termina el metodo sin devolver un valor.
			return

	# Comprueba joystick_vector != Vector2.ZERO; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if joystick_vector != Vector2.ZERO:
		# Llama al metodo rotate_y para realizar esta accion en este punto.
		rotate_y(-joystick_vector.x * controller_sensitivity * delta * 60.0)
		# Llama al metodo camera_3d.rotate_x para realizar esta accion en este punto.
		camera_3d.rotate_x(-joystick_vector.y * controller_sensitivity * delta * 60.0)
		# Guarda en camera_3d.rotation.x el resultado de clamp(camera_3d.rotation.x, deg_to_rad(-89), deg_to_rad(89)).
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-89), deg_to_rad(89))

# Muestra u oculta el cursor del rat?n seg?n la acci?n solicitada.
func see_mouse():
	# Comprueba Input.is_action_just_pressed("see_mouse_click"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if Input.is_action_just_pressed("see_mouse_click"):
		# Llama al metodo print para realizar esta accion en este punto.
		print("veo el mouse")
		# Llama al metodo Input.set_mouse_mode para realizar esta accion en este punto.
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
