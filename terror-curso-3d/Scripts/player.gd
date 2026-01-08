# res://Scripts/player.gd
extends CharacterBody3D
class_name Player

#-------onreadys----------
@onready var camera_3d: Camera3D = $Camera3D
@onready var origCamPos : Vector3 = camera_3d.position
@onready var label: Label = $Label

#----------VARIABLES---------
var canMoveAndRotate := true #sirve para habilitar si se mueve la camara o no
var mouse_sens = 0.25 #sensibilidad con la que rota la camara
var friction := 20 #AL DETENERSE
var direction := Vector3()
var speed := 5 #VELOCIDAD DEL PLAYER
var accel = 5   #ACELERACIÓN 

var joystick_deadzone = 0.2 #saber si el jostic se mueve 
var controller_sensitivity = .05 #sensibilidad del control

var camBobSpeed := 5 #que tan rapido se mueve la camara
var camBobUpDown := 1 #cuanto se mueve de arriba y abajo
var _delta = 0
#***************CAMARA************

func _ready() -> void:
	#se ouclta el mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	#si se puede rotar la camara
	if canMoveAndRotate:
		#entra a la funcion 
		rotate_camera(event)
	


func _process(delta) :
	label.text = $StateMachine.get_state()
	process_camera_jostick()
	#process_input(delta)


func rotate_camera(event):
	# si se mueve el mouse rota el jugador y la camara 
	if event is InputEventMouseMotion:
		#rota el jugador 
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		#se rota de arriba y abajo llamamos a al camara 
		camera_3d.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		#limite de arriba y abajo al rotar la camara
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		 


func process_camera_jostick():
	#funcion de rotar la camara con un control de consola de videojuego
	if Input.get_joy_axis(0,2) < -joystick_deadzone or Input.get_joy_axis(0,2) > joystick_deadzone:
		rotation.y -= Input.get_joy_axis(0,2) * controller_sensitivity
	
	if Input.get_joy_axis(0,3) < -joystick_deadzone or Input.get_joy_axis(0,3) > joystick_deadzone:
		camera_3d.rotation.x = clamp(camera_3d.rotation.x - Input.get_joy_axis(0,3) * controller_sensitivity, -1.55, 1.55)
	


func process_input(delta) -> Vector3:
	_delta += delta
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y 
	var forward_input = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var side_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	direction = Vector3(side_input, 0, forward_input).rotated(Vector3.UP,h_rot).normalized()
	return direction
