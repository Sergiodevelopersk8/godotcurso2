extends Node2D
class_name Cashier

#señal de que se completo la orden con referencia a cashier
signal on_order_clompleted(cashier : Cashier)

#variable de movimiento
@export var move_speed := 50.0

#referencia a la barra de cocinando
@onready var cook_bar: CookBar = $CookBar


#animacion
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#cliente actual
var current_customer :Customer

var counter_pos : Vector2

#variable que guarda referencial al item cliente
var item_request : Item

#variable que guarda la posicion del item
var item_counter_pos: Vector2

#funcion de la referencia del cliente que se debe atender
func set_customer(customer : Customer):
	#cliente que se atiende actualmente
	current_customer = customer
	#este cliente ya esta siendo atendido
	customer.being_served = true
	#referencia del item desdel customer
	item_request = customer.request_item
	#mueve al cashier cerca de la posición del customer
	counter_pos = Vector2(customer.position.x, customer.position.y + 160)
	#obtiene la posicion del item ya sea cafe o hamburguesa
	item_counter_pos = GameManager.get_item_pos(item_request)


func take_order():
	move_to_customer()
	#hacemos un intervalo para que acabe la animación de move
	await get_tree().create_timer(1.1).timeout
	#mustra el pedido del cliente (borra el show request del script de customer 
	#de la funncion de init_customer
	current_customer.show_request()
	#muve al cashier a la otra mesa para preparar el pedido
	move_to_item_position()


func move_to_customer():
	#crea un  tween
	var tween := create_tween()
	tween.tween_property(self, "position", counter_pos, 1.0) 
	#moverlo
	animation_player.play("move")


func move_to_item_position():
	animation_player.play("move")
	#crea un  tween
	var tween := create_tween()
	#moverlo
	tween.tween_property(self,"position", item_counter_pos,1.0)
	#cocinando
	tween.tween_interval(0.3)
	tween.finished.connect(func(): start_cook_time())

func start_cook_time():
	animation_player.play("idle")
	cook_bar.show()
	cook_bar.cook_item(item_request.cook_time)

func deliver_oreder():
	#nos movemos a la posicion del cliente
	move_to_customer()
	#esperamos y emitimos un time out
	await get_tree().create_timer(1.1).timeout
	current_customer.receive_order()
	#obtenemos las monedas 
	GameManager.current_coins += item_request.profit
	#llamamos a la funcion de la moneda
	GameManager.play_coin_vfx(global_position)
	# si faltan unidades por entregar
	if not current_customer.current_order_status <= 0:
		move_to_item_position()
	else:
		animation_player.play("idle")
		current_customer = null
		#emitimos la señal de que se completo
		on_order_clompleted.emit(self)



func _on_cook_bar_on_cook_completed() -> void:
	cook_bar.hide()
	cook_bar.reset_bar()
	deliver_oreder()
