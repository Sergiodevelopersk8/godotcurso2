extends Area2D
class_name Asteroid
@export var min_speed:float
@export var max_speed:float
@export var min_rotation_speed:float
@export var max_rotation_speed:float
var random_speed
var random_rotation_speed


func _ready():
	random_speed = randf_range(min_speed,max_speed)  
	random_rotation_speed = randf_range(min_rotation_speed,max_rotation_speed)


func _process(delta: float) -> void:
	#posicion del asteroide 
	position.x -= random_speed * delta
	rotation_degrees += random_rotation_speed * delta


func _on_area_entered(area: Area2D) -> void:
	var is_laser = area.is_in_group("laser")
	var is_player = area.is_in_group("player") 
	
	if is_player or is_laser :
		queue_free()
