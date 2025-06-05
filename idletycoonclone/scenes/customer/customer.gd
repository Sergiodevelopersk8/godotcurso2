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

func show_request():
	item_box.show()
	item_img.texture = request_item.sprite
	item_label.text = str(request_quantity)
	


func play_move_anim():
	anim_player.play("move")
