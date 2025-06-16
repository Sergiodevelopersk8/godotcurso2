extends Node
class_name CounterManager

#creamos un export para almacenar 4 posiciones
@export var counter_positions: Array[Marker2D]

#creamos un diccionario
var counter : Dictionary[int, Customer] ={
	0:null,
	1:null,
	2:null,
	3:null,
}

#funcion que ve si hay una posición libre en el diccionario
func get_free_index()-> int:
	#recorremos los elementos del diccionario
	for key in counter:
		#si la posicion esta libre
		if counter[key]== null:
			return key
	#retornamos  -1 cuando no existe una posicion libre
	return -1

#asignamos el customer
func assign_customer(customer : Customer):
	var index := get_free_index()
	
	if index == -1 :
		return
	#agrega la referencia del customer
	counter[index] = customer
	#obtenemos la posicion
	var free_counter_pos: Vector2  = counter_positions[index].position
	#accedemos al customer a la variable customer_pos
	#y damos la referencia de la posición
	customer.counter_position = free_counter_pos 
