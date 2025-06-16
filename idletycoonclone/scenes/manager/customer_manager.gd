extends Node
class_name CustomerManager

#variables

#almacena los dos maker en un array
@export var spawn_positions: Array[Marker2D]
#almacena datas de los customers
@export var customer_sprites: Array[CustomerData]

#instanciar referencia del customer
@export var customer_scene: PackedScene

#referencia al counter manager
@onready var counter_manager: CounterManager = %CounterManager


func _ready() -> void:
	spawn_customer()
	

#funcion para instanciar customer
func spawn_customer():
	var customer : Customer = customer_scene.instantiate()
	#lo agregamos al nodo
	add_child(customer)
	
	#obtener sprites randoms
	var sprite_data : CustomerData = customer_sprites.pick_random() 
	#accedemos al nuevo cliente que creamos
	customer.set_sprites(sprite_data)
	
	#obtenemos un item random y cantidad
	var random_item: Item = GameManager.get_random_item()
	var quantity : int = randi_range(1,3)
	customer.init_customer(random_item,quantity)
	
	#validamos si hay una posicion libre
	if counter_manager.get_free_index() != -1:
		#hacemos un spawn a la posicion
		customer.position = spawn_positions[1].position
		#se asigna al diccionario del counter
		counter_manager.assign_customer(customer)
		#movemos el customer
		customer.move_to_counter()
	else:
		#creamos el customer y lo movemos a la derecha
		#variable que almacena los customer randoms
		var random_start_position : Marker2D = spawn_positions.pick_random()
		#posición de el customer e inicia en loa marker posicionados
		customer.global_position = random_start_position.position
		#animacion del customer
		customer.play_move_anim()
		
		#permite animar propiedades de nodos
		var tween := create_tween()
		#anima al customer
		tween.tween_property(customer, "position", 
		customer.position + Vector2.RIGHT * 1300, 4.5)
		#termina la animacion y destruye la instancia del customer
		tween.finished.connect(func(): customer.queue_free() )
	





func _on_spawn_timer_timeout() -> void:
	spawn_customer()
