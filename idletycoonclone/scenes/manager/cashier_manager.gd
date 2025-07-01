extends Node
class_name CashierManager

#almacena la referencia de la escena cashier
@export var cashier_scene: PackedScene

#referencia donde instanciar el cashier
@export var spawn_pos: Marker2D 

@onready var counter_manager: CounterManager = %CounterManager



#arreglo que guardamos la referencia del cashier
var cashier_list : Array[Cashier] = []

func _ready():
	#suscribe a la señal de atender a customer
	GameManager.on_customer_request.connect(_on_customer_request)
	#señal para hacer otro cashier por que se compro en la tienda
	GameManager.on_new_cashier.connect(add_cashier)
	add_cashier()


#funcion que agrega al array cashier
func add_cashier():
	#variable que instancia la escena cashier
	var new_cashier: Cashier = cashier_scene.instantiate()
	#señal de cashier
	new_cashier.on_order_clompleted.connect(_on_order_clompleted)
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

func _on_order_clompleted(cashier : Cashier):
	#obtener un cliente disponible en el counter que no a sido entendido
	var free_customer : Customer = counter_manager.get_first_avilabe_customer()
	#verificamos que no sea nulo
	if free_customer:
		#referencia al nuevo cliente
		cashier.set_customer(free_customer)
		#toma la orden
		cashier.take_order()
