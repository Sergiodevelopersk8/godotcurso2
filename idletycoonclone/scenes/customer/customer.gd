extends Node2D
class_name Customer

#referencias
@onready var body: Sprite2D = %Body
@onready var face: Sprite2D = %Face
@onready var hand_left: Sprite2D = %HandLeft
@onready var hand_right: Sprite2D = %HandRight
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var item_box: Control = $ItemBox
@onready var item_img: TextureRect = %ItemImg
@onready var item_label: Label = %ItemLabel

#guardamos la referencia al item
var request_item : Item
#variable que muestar la cantidad
var request_quantity : int
#variable de cuanto ordena 
var current_order_status : int

#posicion por vector2
var counter_position : Vector2
#variable de que el cliente ya esta siendo atendido
var being_served : bool 
#decir que el cliente llega a la posicion del counter y en espera de 
#que lo atiendan
var waiting_order: bool


func _process(delta: float) -> void:
	item_label.text = str(current_order_status)


func init_customer(item : Item, quantity : int):
	#inicializamos la referencia
	request_item = item
	#cantidad del pedido
	request_quantity = quantity
	#estado actual de la cantidad
	current_order_status= quantity



#funcion que permite actualizar texturas de customer
func set_sprites(data: CustomerData):
	#acceder al nodo y cambiar texturas
	body.texture = data.body
	face.texture = data.face
	hand_left.texture = data.hand
	hand_right.texture = data.hand

#funcion de mover el customer
func move_to_counter():
	#animacion de mover
	play_move_anim()
	#guarda la posicion unos pixeles antes del counter
	var counter_top_pos := Vector2(counter_position.x,position.y)
	#tween para animar una propiedad y llegar al counter
	var tween := create_tween()
	tween.tween_property(self, "position", counter_top_pos, 1.0 )
	tween.tween_interval(0.2)
	#lo movemos a la posicion del counter
	tween.tween_property(self, "position", counter_position, 1.0 )
	tween.tween_interval(0.5)
	#finalizamos el tween y usamos la animación de idle
	tween.finished.connect(func():
		anim_player.play("idle")
		waiting_order = true
		#funcion del game manager y su referencia a si mismo
		GameManager.on_customer_request.emit(self)
		)




func show_request():
	item_box.show()
	item_img.texture = request_item.sprite
	item_label.text = str(request_quantity)
	
	

#funcion de recibir orden
func receive_order():
	#reduce la cantidad de orden
	current_order_status -= 1
	#valida la orden actual ya se completo 
	if current_order_status <= 0 :
		#llamamos ala funcion de oreden completada
		oreder_completed()

func oreder_completed():
	item_box.hide()
	waiting_order = false
	#variable para mover customer cuando fue atendido
	var counter_top_position = counter_position.y - 180
	var tween = create_tween()
	#mueve al customer 
	tween.tween_property(self, "position",Vector2(counter_position.x, counter_top_position), 1.0)
	tween.tween_interval(0.2)
	tween.tween_property(self, "position",Vector2(counter_position.x + 800, counter_top_position), 3.0)
	tween.tween_interval(0.2)
	#nos conectamos y finalizamos
	tween.finished.connect(func(): GameManager.on_customer_order_completed.emit(self))


func play_move_anim():
	anim_player.play("move")
