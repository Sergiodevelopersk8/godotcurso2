extends Node

@export var coffe : Item 
@export var burger : Item

#funcion que regresa un item de manera random
func get_random_item() -> Item:
	# creamos un array 
	var items: Array = [coffe,burger]
	#retornamos el array de manera random
	return items.pick_random() 
