extends Node
#game manager script


#señal que notifica que un cliente quiere ser atendido
signal on_customer_request(customer: Customer)
#señal de orden completada
signal on_customer_order_completed(customer : Customer)

#señal para crear un nuevo cashier cuando se compre en tienda
signal on_new_cashier

#referencia a la escena particula de las monedas
const COIN_VFX = preload("res://scenes/extra/coin_vfx.tscn")


#variable que almacena un item que es hamburguesa y cafe
@export var coffe : Item 
@export var burger : Item

#variables de la posicion del item cafe hamburguesa
var coffe_counter_pos := Vector2(425, 1250)  
var burguer_counter_pos := Vector2(680,1250) 
 
#mondeas actuales 
var current_coins : int = 200000
#funcion que regresa un item de manera random
func get_random_item() -> Item:
	# creamos un array 
	var items: Array = [coffe,burger]
	#retornamos el array de manera random
	return items.pick_random() 

#funcion donde se obtiene la posicion dle item hamburguesa o cafe
func get_item_pos(item: Item) -> Vector2:
	#switch para saber el item y su tipo
	match item.type:
		Item.ItemType.Coffe:
			return coffe_counter_pos 
		Item.ItemType.Burger:
			return burguer_counter_pos
	return Vector2.ZERO
	

func play_coin_vfx(spawn_pos: Vector2):
	#creamos una variable para la instancia
	var coin_instance = COIN_VFX.instantiate()
	#obtenemos el arbol de nodos y lo instanciamos 
	get_tree().root.add_child(coin_instance)
	#sonido de recoger monedas
	SoundManager.play_coins()
	#variable para modificar su posicion de spawn 
	var new_pos := Vector2(spawn_pos.x, spawn_pos.y - 70)
	coin_instance.global_position = new_pos
	#accedemos a su emiting de la moneda, 
	# one shot de la moneda debe estar activado
	coin_instance.emitting = true
	#señal para finalizar y eliminar de memoria con funcion anonima
	coin_instance.finished.connect(func(): coin_instance.queue_free())
	
	
