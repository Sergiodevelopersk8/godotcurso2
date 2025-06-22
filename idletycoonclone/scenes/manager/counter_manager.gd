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

func _ready() -> void:
	GameManager.on_customer_order_completed.connect(_on_customer_order_completed)


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

#regresa el primer cliente disponible
func get_first_avilabe_customer()-> Customer:
	#recorremos para ver si son nulo
	for customer : Customer in counter.values():
		#si no es nulo
		if customer != null:
			#si el cliente esta en espera y no a sido atendido
			if customer.waiting_order and not customer.being_served:
				return customer
	
	return null

func _on_customer_order_completed(customer : Customer):
	#liberamos la referencia
	#lo llamamos x para counter
	for x : int in counter:
		# si counter en la posicion x es igual a customer
		if counter[x] == customer:
			#su nuevo valor sera nulo
			counter[x] = null
	
