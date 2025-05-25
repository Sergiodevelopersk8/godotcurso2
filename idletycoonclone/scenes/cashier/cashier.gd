extends Node2D
class_name Cashier

#variable de movimiento
@export var move_speed := 50.0

#animacion
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func move_to_customer():
	#crea un  tween
	#moverlo
	animation_player.play("move")


func move_to_item_position():
	#crea un  tween
	#moverlo
	#start cook time
	animation_player.play("idle")
