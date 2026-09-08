#res://assets/models/Player/player.gd
extends CharacterBody3D
class_name Player


#-------onreadys----------
@onready var camera_3d: Camera3D = $Camera3D
@onready var origCamPos : Vector3 = camera_3d.position
@onready var footstep_sound: FootstepPlayer = $FootstepSound
@onready var ray_cast_interactuar: Interactor3D = $Camera3D/RayCastInteractuar

#-------onreadys state_machines----------
@onready var state_machine: StateMachine = $StateMachine


#-------onreadys raycast----------
@onready var ray_cast_ground_detector: RayCast3D = $Raycasts/RayCastGroundDetector
@onready var raycast_crouch: RayCast3D = $Raycasts/RaycastCrouch
@onready var hand: Marker3D = $Camera3D/hand



#----------VARIABLES CAMARA---------
var move_and_rotate_player := true #sirve para habilitar si se mueve la camara o no
var mouse_sens = 0.25 #sensibilidad con la que rota la camara
var friction := 20 #AL DETENERSE
var direction := Vector3()

# --------- VARIABLES DE VELOCIDADES, GRAVEDAD Y MOVIMIENTO_DE_CAMARA -----------
var speed := 3    # Velocidad normal de caminata
var run_speed := 6.0   # Velocidad al correr (Añadir esta línea)
var accel := 5      # Aceleración



#--------- VARIABLES DE VELOCIDADES, GRAVEDAD Y MOVIMIENTO_DE_CAMARA -----------
var jump_Force = 20
var ACCEL_AIR = 5
const gravity = 50
var joystick_deadzone = 0.2 #saber si el jostic se mueve 
var controller_sensitivity = .05 #sensibilidad del control
var cam_Bob_Speed := 5 #que tan rapido se mueve la camara
var cam_Bob_Up_Down := 1 #cuanto se mueve de arriba y abajo
var _delta = 0
var distance_foot_step = 0.0
var play_foot_step := 1

#--------- SEÑALES -----------
signal interactable_focused(description: String)




#--------- FUNCIONES DEL SISTEMA -----------


func _ready() -> void:
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	





func _input(event: InputEvent) -> void:
	# 1. Si no se permite mover/rotar, cancelamos CUALQUIER procesamiento de entrada
	if not move_and_rotate_player:
		return
	# 2. Solo si move_and_rotate_player es true, procesamos la cámara
	if event is InputEventMouseMotion:
		rotate_camera(event)




func _process(delta: float) -> void:
	
	if move_and_rotate_player:
		rotate_camera_joystick(delta) # Activamos la rotación con joystick
		
	if direction == Vector3.ZERO:
		camera_3d.position = camera_3d.position.lerp(origCamPos, delta * 5)
		
	see_mouse()



#--------- FUNCIONES PROPIAS -----------

func rotate_camera(event):
	# si se mueve el mouse rota el jugador y la camara 
	if event is InputEventMouseMotion :
		#rota el jugador 
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		#se rota de arriba y abajo llamamos a al camara 
		camera_3d.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		#limite de arriba y abajo al rotar la camara
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-89), deg_to_rad(89))


func rotate_camera_joystick(delta: float) -> void:
	delta = 2
	if not move_and_rotate_player:
		return
		
	var joystick_vector := Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down", joystick_deadzone)
	
	if joystick_vector != Vector2.ZERO:
		rotate_y(-joystick_vector.x * controller_sensitivity * delta)
		camera_3d.rotate_x(-joystick_vector.y * controller_sensitivity * delta)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-89), deg_to_rad(89))


func process_input(delta) -> Vector3:
	_delta += delta
	direction = Vector3.ZERO
	
	
	
	var h_rot = global_transform.basis.get_euler().y 
	var forward_input = Input.get_action_strength("down") - Input.get_action_strength("up")
	var side_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	direction = Vector3(side_input, 0, forward_input).rotated(Vector3.UP,h_rot).normalized()
	return direction





func see_mouse():
	if Input.is_action_just_pressed("see_mouse_click"):
		print("veo el mouse")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
