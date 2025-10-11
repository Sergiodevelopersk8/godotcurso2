extends Area2D
class_name Laser

@export var speed = 500.5
@onready var sprite_laser: Sprite2D = $Sprite2D


func _process(delta):
	position.x += speed * delta
	
