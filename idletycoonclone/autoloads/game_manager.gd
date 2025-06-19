extends Node

#señal que notifica que un cliente quiere ser atendido
signal on_customer_request(customer: Customer)

#variable que almacena un item que es hamburguesa y cafe
@export var coffe : Item 
@export var burger : Item

#variables de la posicion del item cafe hamburguesa
var coffe_counter_pos := Vector2(425, 1250)  
var burguer_counter_pos := Vector2(680,1250)  

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
	
