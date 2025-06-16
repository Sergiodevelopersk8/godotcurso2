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
var request_quantity : int
var current_order_status : int

#posicion por vector2
var counter_position : Vector2

var being_served : bool 

func init_customer(item : Item, quantity : int):
	request_item = item
	request_quantity = quantity
	current_order_status= quantity
	show_request()


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
		#funcion del game manager y su referencia a si mismo
		GameManager.on_customer_request.emit(self)
		)




func show_request():
	item_box.show()
	item_img.texture = request_item.sprite
	item_label.text = str(request_quantity)
	


func play_move_anim():
	anim_player.play("move")
