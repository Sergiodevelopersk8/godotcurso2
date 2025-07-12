extends CharacterBody2D
class_name Player

#variables
@export var max_speed := 180
@export var jump_force := 450
@export var max_jumps := 2
@export var gravity := 1600.0

#referencias al nodo de visuals animaciones y raycast
@onready var visuals: Node2D = $Visuals
@onready var anim_sprite: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var ray_cast: RayCast2D = $Visuals/RayCast2D

#guardar los saltos que quedan
var jump_left : int

#direccion en la que nos movemos
var move_direction := 1
var can_move := true

func _ready() -> void:
	#cantidad de saltos permitidos
	reset_jump()


func _physics_process(delta: float):
	# si no podemos movernos
	if not can_move:
		return
	#si podemos movernos llamamos la funcion
	handle_movement()
	handle_gravity(delta)
	handle_wall_collision()
	handle_jump_input()
	move_and_slide()

#mueve el personaje
func handle_movement():
	#movimiento horizontal
	velocity.x = move_direction * max_speed
	#si esta en el piso
	if is_on_floor():
		#muestro la animacion
		anim_sprite.play("run")
		#resetear los saltos
		reset_jump()

func handle_gravity(delta: float):
	#aplicamos la gravedad si el personahe no esta en el piso
	if not is_on_floor():
		velocity.y += gravity * delta
	

func handle_wall_collision():
	#verificamos si no colisionamos con las paredes
	if not ray_cast.is_colliding():
		return
	
	#si estamos colisionando con las paredes
	velocity.y = 50
	reset_jump()
	anim_sprite.play("fall")
	
	if is_on_floor():
		change_direction()

func handle_jump_input():
	#verificamos la accionde saltar
	if not Input.is_action_just_pressed("tap"):
		return 
	#verificamos la colision
	if ray_cast.is_colliding():
		change_direction()
		jump()
	else:
		jump()

func jump():
	#veridicamos los slatos
	if jump_left <= 0:
		return
	
	velocity.y = -jump_force
	jump_left -= 1
	if jump_left <= 0:
		anim_sprite.play("double_jump")
	else:
		anim_sprite.play("jump")

func change_direction():
	#cambiar la direccion
	move_direction *= -1
	#rotar el sprite a la posicion que vea
	visuals.scale.x *= -1


func reset_jump():
	jump_left = max_jumps


func player_dead():
	can_move = false
	velocity = Vector2.ZERO
	anim_sprite.play("dead")
