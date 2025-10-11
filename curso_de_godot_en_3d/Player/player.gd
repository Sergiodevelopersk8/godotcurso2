extends CharacterBody3D
class_name Player

# velocidad
@export var speed = 15
# velocidad de salto
@export var jump_velocity = 4.5
# gravedad del jugador
@export var gravity = 9.8

# variable para respawnear 
var respawnPosition = Vector3(0,0,0)

# var de rotar la camara con el raton
var mouse_sensitivity_horizontal = 0.1
var mouse_sensitivity_vertical = 0.1

@onready var camera_arm: Node3D = $CameraArm

@onready var animplayer: AnimationPlayer = $gobot/AnimationPlayer

@onready var modelo = $gobot


func _ready() -> void:
	#ocultar el raton
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	animplayer.play("Idle")


func _physics_process(delta: float) -> void:
	animaciones()
	#MOSTRAR EL RATON
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# llama la funcion para mover al player
	move_player(delta)

func _process(delta: float) -> void:
	if is_moving():
		
		var look_rotate = Vector2(velocity.z,velocity.x)
		modelo.rotation.y = lerp_angle(modelo.rotation.y, look_rotate.angle(), delta * 12)
	

func move_player(delta: float):
	
	#var direction = Vector3.ZERO
	var input_dir = Vector3.ZERO
	# mapeos de las teclas para mover al personaje
	if Input.is_action_pressed("derecha"): 
		input_dir.x += 1

		
	if Input.is_action_pressed("izquierda") : 
		input_dir.x -= 1

	if Input.is_action_pressed("arriba"): 
		input_dir.z -= 1

	if Input.is_action_pressed("abajo"): 
		input_dir.z += 1

	
	# normalizamos para evitar boost en diagonal
	input_dir = input_dir.normalized()
	# Convertimos dirección local a global según la rotación del jugador
	
	
	# valida si puede saltar
	if  is_on_floor() and Input.is_action_pressed("jump"):
		animplayer.play("Jump",0.5)
		# aplica el salto 
		velocity.y = jump_velocity
	
	# llama a la funcion de la muerte
	zone_deadth()
	
	#ajusta el vector para que siempre tenga una longitud de 1 
	# manteniendo la dirección, así no hay “boost” en diagonal.
	# asegura que todas las direcciones tengan la misma velocidad.
	# normalizamos para evitar boost en diagonal
	input_dir = input_dir.normalized()

	# convertir a dirección global según rotación del jugador
	var cam_yaw = camera_arm.global_transform.basis.get_euler().y
	var direction = (Basis(Vector3.UP, cam_yaw) * input_dir).normalized()
	
	
	#traduce intención de movimiento a desplazamiento real.
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	#gravedad
	gravedad(delta)
	
	#rotarModelo(velocity.z,velocity.x, delta)
	
	move_and_slide()

func gravedad(delta: float):
	# Gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta

#func rotarModelo(velocidad_z,velocidad_x, delta):




func zone_deadth():
	if position.y < -25:
		position = respawnPosition
		return
	return

#funcion de rotar camara
func _input(event) :
	# mover el raton
	if event is  InputEventMouseMotion:
		#comprobar si el raton esta oculto
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity_horizontal))
			camera_arm.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity_vertical))
			#limites de rotacion de la camara
			camera_arm.rotation.x = clamp(camera_arm.rotation.x, deg_to_rad(-90.0),deg_to_rad(30.0))

func is_moving():
	return abs(velocity.z) > 0 || abs(velocity.x) > 0

func animaciones():
	if is_on_floor():
		if is_moving():
			animplayer.play("Run",0.5)
		else:
			animplayer.play("Idle",0.5)
