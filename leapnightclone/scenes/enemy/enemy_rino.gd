extends CharacterBody2D
class_name EnemyRino

#variables

#longitud de raycast para detectar al player
@export var ray_lenght := 165.0

#almacenar la velocidad del movimiento
@export var move_speed := 50.0

#referencia
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_ray_cast: RayCast2D = $WallRayCast
@onready var player_ray_cast: RayCast2D = $PlayerRayCast

#almacena la direccion del movimiento
var direcction := 1

#detener o mover 
var can_move := false


var defeated := false

func _ready() -> void:
	player_ray_cast.target_position.x =  ray_lenght


func _process(delta: float) -> void:
	#saber si colisionamos
	if player_ray_cast.is_colliding():
		can_move = true
	
	#si nos podemos mover
	if can_move:
		velocity.x = direcction * move_speed
		anim_sprite.play("run")
		move_and_slide()
	
	#verificamos si colicionamos con el muro
	if wall_ray_cast.is_colliding():
		can_move = false
		#modificar horientacion
		direcction *= -1
		anim_sprite.play("hit_wall")
		await get_tree().create_timer(0.8).timeout
		rotate_rino(direcction)
		anim_sprite.play("idle")
	

func rotate_rino(direcction : int):
	# cambiamos la direccion 
	anim_sprite.scale.x = direcction
	#cambiar la direccion de loas raycast
	wall_ray_cast.scale.x  = direcction
	player_ray_cast.scale.x = direcction


func _on_top_area_body_entered(body: Node2D) -> void:
	 # verifico si la colision es contra el player.
	if not body is Player:
		return
	
	defeated = true
	can_move = false
	anim_sprite.play("hit")
	await get_tree().create_timer(1.2).timeout
	queue_free()


func _on_bottom_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	if defeated:
		return
	
	EventManager.on_played_dead.emit()
