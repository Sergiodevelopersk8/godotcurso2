extends Node2D
class_name Customer

#referencias
@onready var body: Sprite2D = %Body
@onready var face: Sprite2D = %Face
@onready var hand_left: Sprite2D = %HandLeft
@onready var hand_right: Sprite2D = %HandRight
@onready var anim_player: AnimationPlayer = $AnimationPlayer



#funcion que permite actualizar texturas de customer
func set_sprites(data: CustomerData):
	#acceder al nodo y cambiar texturas
	body.texture = data.body
	face.texture = data.face
	hand_left.texture = data.hand
	hand_right.texture = data.hand

func play_move_anim():
	anim_player.play("move")
