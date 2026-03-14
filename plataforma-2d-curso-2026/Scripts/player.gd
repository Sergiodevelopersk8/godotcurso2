class_name Player
extends CharacterBody2D

@export var speed : float


var is_facing_right = true #esta mirando a la derecha

func _physics_process(delta: float) -> void:
	move_x()
	
	move_and_slide()

func move_x():
	var input_axis = Input.get_axis("left","right") #para mover con las flechas
	velocity.x = input_axis * speed #velocidad del movimiento x

func flip_player():
	#si mira  ala derecha y aprieto a la izquierda 
	#si esta mirando a la izquierda y aprieto  a la derecha
	
	if (is_facing_right and velocity.x < 0) or  (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right
