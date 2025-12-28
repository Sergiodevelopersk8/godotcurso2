extends Marker2D
class_name AsteroidSpawner

#instanciar las escenas de los asteroides en un array
@export var asteroids:Array[PackedScene]
@export var min_y : float 
@export var max_y : float
@export var destroy_asteroid_screen : float
@onready var timer: Timer = $Timer




func create_asteroid():
	if GameManager.is_game_over:
		timer.stop()
	
	#genera alateoria del array de los asteroides
	var random_asteroid_scene = asteroids.pick_random()
	#se genera la instancia del asteroide
	var random_asteroid_instance = random_asteroid_scene.instantiate()
	#lo aghrega como hijo
	add_child(random_asteroid_instance)
	var random_y = randf_range(min_y, max_y)
	random_asteroid_instance.global_position.y = random_y
	

func destroy_Asteroid():
	
	queue_free()


#intervalos de tiempo de spawner
func _on_timer_timeout() -> void:
	create_asteroid()
	#var instances = 3
	#for i in range(instances): create_asteroid()
