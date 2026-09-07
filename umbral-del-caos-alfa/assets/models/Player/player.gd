#res://assets/models/Player/player.gd
extends CharacterBody3D
class_name Player


#-------onreadys----------
@onready var camera_3d: Camera3D = $Camera3D
@onready var origCamPos : Vector3 = camera_3d.position
@onready var footstep_sound: AudioStreamPlayer = $FootstepSound

#-------onreadys state_machines----------
@onready var state_machine: StateMachine = $StateMachine


#-------onreadys raycast----------
@onready var ray_cast_interactuar: RayCast3D = $Camera3D/RayCastInteractuar
@onready var ray_cast_ground_detector: RayCast3D = $Raycasts/RayCastGroundDetector
@onready var raycast_crouch: RayCast3D = $Raycasts/RaycastCrouch
@onready var hand: Marker3D = $Camera3D/hand



#----------VARIABLES CAMARA---------
var move_and_rotate_player := true #sirve para habilitar si se mueve la camara o no
var mouse_sens = 0.25 #sensibilidad con la que rota la camara
var friction := 20 #AL DETENERSE
var direction := Vector3()


#--------- VARIABLES DE VELOCIDADES, GRAVEDAD Y MOVIMIENTO_DE_CAMARA -----------
var speed := 3 #VELOCIDAD DEL PLAYER
var accel = 5   #ACELERACIÓN 
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
const FOOTSTEP_AUDIO_MAP ={
		"Grass": preload("res://assets/audio/SFX/footsteps/grass/0.ogg"),
		"Metal": preload("res://assets/audio/SFX/footsteps/metal/0.ogg"),
		"Concrete":preload("res://assets/audio/SFX/footsteps/wood/0.ogg"),
		"Terrazzo":preload("res://assets/audio/SFX/footsteps/wood/0.ogg")
	}
const DEFAULT_FOOTSTEP = preload("res://assets/audio/SFX/footsteps/boots/0.ogg")


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
	interactions()
	if move_and_rotate_player:
		#state_machinse_label.text = $StateMachine.get_state()
		Sound_Steps()
	if direction == Vector3.ZERO:
		camera_3d.position = camera_3d.position.lerp(origCamPos, delta * 5)
	see_mouse()




#--------- FUNCIONES PROPIAS -----------

func rotate_camera(event):
	# si se mueve el mouse rota el jugador y la camara 
	if event is InputEventMouseMotion:
		#rota el jugador 
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		#se rota de arriba y abajo llamamos a al camara 
		camera_3d.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		#limite de arriba y abajo al rotar la camara
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-89), deg_to_rad(89))


func process_input(delta) -> Vector3:
	_delta += delta
	direction = Vector3.ZERO
	
	
	
	var h_rot = global_transform.basis.get_euler().y 
	var forward_input = Input.get_action_strength("down") - Input.get_action_strength("up")
	var side_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	direction = Vector3(side_input, 0, forward_input).rotated(Vector3.UP,h_rot).normalized()
	return direction


func interactions():
	# Si la cámara/movimiento están desactivados, NO detectar interacciones
	if not move_and_rotate_player:
		
		interactable_focused.emit("")
		return

	var seen_object = comprobar_interacciones()
	
	if seen_object != null and seen_object.get("id"):
		
		interactable_focused.emit(seen_object.id)
	else:
		interactable_focused.emit("")
		
	


func comprobar_interacciones() -> Interact:
	if ray_cast_interactuar.is_colliding():
		var colisionador = ray_cast_interactuar.get_collider()
		#if colisionador.is_in_group("Interacts"):
		if colisionador is Interact:
			return colisionador # Si todo está bien, devuelve el objeto
	return null # Si no está colisionando o no es del grupo, devuelve un vacío limpio


func see_mouse():
	if Input.is_action_just_pressed("see_mouse_click"):
		print("veo el mouse")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



func Sound_Steps():
	
	var sound_state = state_machine.get_state()
	
	match sound_state:
		"Run":
			play_foot_step = 2
		"Walk":
			play_foot_step = 3
		"Crouch":
			play_foot_step = 5
		_:
			play_foot_step = 100
	
	if play_foot_step != 100 and (int(velocity.x) != 0) || int (velocity.z) != 0:
		distance_foot_step += .1
	
	if distance_foot_step > play_foot_step and is_on_floor():
		if ray_cast_ground_detector.is_colliding():
			var ground_name = ray_cast_ground_detector.get_collider().get_parent()
			
			if ground_name != null and ground_name is MeshInstance3D and ground_name.get_active_material(0) != null:
				var nameMat = ground_name.get_active_material(0).resource_path
				floor_sounds_path(nameMat)
		footstep_sound.pitch_scale = randf_range(.8,1.2)
		footstep_sound.play()
		distance_foot_step = 0
	








func floor_sounds_path(nameMat: String):
	
	#si no existe reproduce el sonido por default
	var selected_stream: AudioStream = DEFAULT_FOOTSTEP
	
	#recorremos el diccionario de sonidos precargados
	for key in FOOTSTEP_AUDIO_MAP.keys():
		#si existe el nombre en el diccionario 
		if key in nameMat:
			#lo pasamos al valor de stream
			selected_stream = FOOTSTEP_AUDIO_MAP[key]
			break
	footstep_sound.stream = selected_stream 
	
