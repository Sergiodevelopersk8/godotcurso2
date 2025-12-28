extends Area2D
class_name Asteroid
#exporta en el inspector para poner el valor 
@export var min_speed:float 
@export var max_speed:float
@export var min_rotation_speed:float
@export var max_rotation_speed:float
@export var points : int 
@export var explosion_scene: PackedScene
var random_speed
var random_rotation_speed

func _ready():
	#random de la velocidad de los asteroides
	random_speed = randf_range(min_speed,max_speed)  
	#random del giro de los asteroides
	random_rotation_speed = randf_range(min_rotation_speed,max_rotation_speed)


func _process(delta: float) -> void:
	#posicion del asteroide 
	position.x -= random_speed * delta
	rotation_degrees += random_rotation_speed * delta


func _on_area_entered(area: Area2D) -> void:
	#guarda la referencia de los grupos
	var is_laser = area.is_in_group("laser")
	var is_player = area.is_in_group("player") 
	
	if is_laser:
		GameManager.add_score(points)
	
	#si colisiona el meteorito con el laser o el player este se elimina
	if is_player or is_laser :
		destroy()



func destroy():
	var explosion_instance = explosion_scene.instantiate()
	add_sibling(explosion_instance)
	explosion_instance.position = position
	queue_free()
