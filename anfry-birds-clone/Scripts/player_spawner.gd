extends Marker2D
class_name PlayerSpawner

#@export var player_scene:PackedScene
const player_scene = preload("uid://caxcp52mfylon")


signal player_spawned(player_instance)


func _ready() -> void:
	create_player()
	



func create_player():
	var player_instance = player_scene.instantiate()
	#añadimos y pospongamos la llamada para que se cargue todo
	#y cargue el jugador despues de todo
	add_sibling.call_deferred(player_instance)
	player_instance.position = position
	
	# formas de conectar 
	
	# 1.conexion por señal creada
	#player_instance.tree_exited.connect(_on_player_tree_exited)
	
	# 2.llamar al metodo mismo
	player_instance.tree_exited.connect(create_player)
	
	player_spawned.emit(player_instance)

func _on_player_tree_exited():
	create_player()
