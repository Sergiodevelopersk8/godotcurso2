extends CharacterBody2D

class_name Player
@onready var player: CharacterBody2D = $"."

@export var speed = 500.0
@onready var sprite_2d: Sprite2D = $Sprite2D
var y_input 
var x_input

func _physics_process(delta) :
	player_move(x_input,y_input)



func player_move(x,y):
	y = Input.get_axis("up","down")
	x = Input.get_axis("left","right")
	velocity = Vector2(x, y) * speed
	move_and_slide()
