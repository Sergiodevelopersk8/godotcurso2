extends Node

#señal que notifica que un cliente quiere ser atendido
signal on_customer_request(customer: Customer)

#variable que almacena un item que es hamburguesa y cafe
@export var coffe : Item 
@export var burger : Item

#funcion que regresa un item de manera random
func get_random_item() -> Item:
	# creamos un array 
	var items: Array = [coffe,burger]
	#retornamos el array de manera random
	return items.pick_random() 
