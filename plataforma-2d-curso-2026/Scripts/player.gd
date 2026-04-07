class_name Player
extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $Sprite2D



@export var speed : float
@export var jump_speed : float
@export var gravity : float
var cambio_animacion : String
var is_facing_right = true #esta mirando a la derecha

func _physics_process(delta: float) -> void:
	move_x()
	flip_player()
	jump_player(delta)
	update_animations()
	move_and_slide()

func move_x():
	var input_axis = Input.get_axis("left","right") #para mover con las flechas
	velocity.x = input_axis * speed #velocidad del movimiento x

func flip_player():
	#si mira  ala derecha y aprieto a la izquierda 
	#si esta mirando a la izquierda y aprieto  a la derecha
	
	if (is_facing_right and velocity.x < 0) or  (not is_facing_right and velocity.x > 0):
		scale.x *= -1 #si esta en 1 pasa a -1 si este estaba en -1 pasa a 1 para girar los nodos
		is_facing_right = not is_facing_right # si esta true pasa a false y si estaba en false pasa true

func jump_player(delta):
	#salto del jugador
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed 
		
	
	if not is_on_floor(): # si no esta en el piso aplica la gravedad
		velocity.y += gravity * delta #aplico gravedad a el player
		

func update_animations():
	if not is_on_floor():
		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")
		return
	if velocity.x != 0:
		anim.play("run")
	else:
		anim.play("idle")


func _on_hurtbox_area_entered(area: Area2D) -> void:
	queue_free()
