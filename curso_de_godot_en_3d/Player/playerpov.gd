extends CharacterBody3D

class_name PlayerPov

#velocidad al caminar
@export var speed: float = 5.0
@export var jump := 4.0
@export var sensivilidad_mouse := 0.005
@export var gravity = 9.8
@onready var camera: Camera3D = $Camera3D




#tope vertical de la camara
var pitch := 0.0

func _ready() -> void:
	#no ver el mouse 
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	#mover la camara libre 
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensivilidad_mouse)
		
		pitch = clamp(pitch - event.relative.y * sensivilidad_mouse, deg_to_rad(-89), deg_to_rad(89))
		camera.rotation.x = pitch
	
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	




func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("arriba"):
		direction -= transform.basis.z 
	if Input.is_action_pressed("abajo"):
		direction += transform.basis.z
	if Input.is_action_pressed("derecha"):
		direction += transform.basis.x
	if Input.is_action_pressed("izquierda"):
		direction -= transform.basis.x
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jump
	
	direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	
	gravedad(delta)
	move_and_slide()


func gravedad(delta: float):
	# Gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta
