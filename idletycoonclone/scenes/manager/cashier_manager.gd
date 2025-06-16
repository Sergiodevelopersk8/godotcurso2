extends Node
class_name CashierManager

#almacena la referencia de la escena cashier
@export var cashier_scene: PackedScene

#referencia donde instanciar el cashier
@export var spawn_pos: Marker2D 

#arreglo que guardamos la referencia del cashier
var cashier_list : Array[Cashier] = []

func _ready():
	#suscribe a la señal de atender a customer
	GameManager.on_customer_request.connect(_on_customer_request)
	add_cashier()


#funcion que agrega al array cashier
func add_cashier():
	#variable que instancia la escena cashier
	var new_cashier: Cashier = cashier_scene.instantiate()
	#agrega el nuevo cashier
	add_child(new_cashier)
	#modificamos su posicon para que sea igual a spawn_pos 
	new_cashier.position = spawn_pos.position
	#accedemos al arreglo y agregamos el new cashier
	cashier_list.append(new_cashier)

func _on_customer_request(customer : Customer):
	#obtener un nuevo arreglo apartir del cashier_list
	var free_cashiers : Array[Cashier] = cashier_list.filter(
		func(x : Cashier): return x.current_customer == null)
	#si no hay ningun elemento en el arreglo regresamos
	if not free_cashiers:
		return
	#el cashier randmo atiende 
	var random_cashier: Cashier = free_cashiers.pick_random()
	
	#verifico si casier random existe
	if random_cashier:
		random_cashier.set_customer(customer)
		#toma la orden
		random_cashier.take_order()
