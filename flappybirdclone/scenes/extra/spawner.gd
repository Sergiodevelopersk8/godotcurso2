extends Node

class_name Spawner

#escucha si un osbtaculo colisiono
signal on_obstacle_crash



#guardamos la referencia de obstacle
const OBSTACLE_SCENE = preload("res://scenes/Obstacle/obstacle.tscn")

#referencia al nodo timer 
@onready var timer: Timer = $Timer


func spawn_obstacle():
	#crea una estancia del obstaculo
	var obs_instance : Obstacle = OBSTACLE_SCENE.instantiate()
	#accedemos al signal  de choque
	obs_instance.on_player_crashed.connect(_on_player_crashed)
	
	
	# referencia de la ventana de main
	var viewport: Viewport = get_viewport()
	
	#obtiene la posicion global del viewport
	obs_instance.position.x = viewport.get_visible_rect().end.x + 150
	
	#obtener posicion central en y
	var half_height = viewport.size.y / 2
	#regresar un valor random en la posicion
	obs_instance.position.y = randf_range(half_height + 240, half_height - 50)
	#se agrega como hijo
	add_child(obs_instance)


func stop_obstacles():
	#detengo el timer
	#para no spawnear más obtaculos
	timer.stop()
	#recorre los hijos de spawner que se instancian y se filtran los que son
	#obstacle y se nombrara como x
	for obs : Obstacle in get_children().filter(func(x): return x is Obstacle):
		#funcion que se llama desde obstacle y para que ya no se muevan
		obs.set_speed(0)



#funcion de el signal que va a ser llamado en 
#obs_instance.on_player_crashed.connect(_on_player_crashed)
func _on_player_crashed():
	on_obstacle_crash.emit()
	stop_obstacles()




func _on_timer_timeout() -> void:
	#instancia la funcion
	spawn_obstacle()
