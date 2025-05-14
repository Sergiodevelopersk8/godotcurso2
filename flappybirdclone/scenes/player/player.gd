extends CharacterBody2D
class_name Player
#evento de game

signal on_game_started


#variables
@export var gravity := 1000.0
@export var jump_force := 400.0
@export var max_speed := 400.0
@export var rotation_speed := 2.0
@onready var jump_audio: AudioStreamPlayer2D = $jumpAudio




var is_started := false
var should_process_input := true






func _physics_process(delta):
	if Input.is_action_just_pressed("jump") and should_process_input:
		if is_started == false:
			is_started = true
			on_game_started.emit()
		
		jump()
	
	if is_started == false:
		return
	
	
	#mover el objeto aceleración 
	velocity.y += gravity * delta
	#regresa el valor que sea el menor y se asigna a 
	#velocity.y
	velocity.y = min(velocity.y, max_speed)
	
	
	move_and_slide()
	rotate_player()


#salto del jugador
func jump():
	#se mueve hacia arriba
	velocity.y = -jump_force
	#gira el player hacia arriba
	rotation = deg_to_rad(-30)
	jump_audio.play()
	


func rotate_player():
	# se evalua la velocidad y la rotacion del player
	if velocity.y > 0 and rad_to_deg(rotation) < 90 :
		# rota al personaje
		rotation += rotation_speed * deg_to_rad(1)


func stop_movement():
	# DETIENE EL MOVIMIENTO DEL PLAYER
	should_process_input = false

func stop_gravity():
	# reset a la gravedad player
	gravity = 0
	velocity = Vector2.ZERO
