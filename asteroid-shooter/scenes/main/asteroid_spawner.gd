extends Marker2D

#instanciar la escena de asteroide grande

@export var big_asteroid_scene : PackedScene
@export var min_y : float 
@export var max_y : float
@export var destroy_asteroid_screen : float

func create_asteroid():
	#se genera la instancia del asteroide
	var big_asteroid_instance = big_asteroid_scene.instantiate()
	add_child(big_asteroid_instance)
	var random_y = randf_range(min_y, max_y)
	big_asteroid_instance.global_position.y = random_y
	print("posicion del asteroide x ",big_asteroid_instance.global_position.x)
	

func destroy_Asteroid():
	queue_free()


#intervalos de tiempo de spawner
func _on_timer_timeout() -> void:
	create_asteroid()
