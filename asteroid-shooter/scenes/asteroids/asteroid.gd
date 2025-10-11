extends Area2D

@export var speed: float = 250



func _process(delta: float) -> void:
	#posicion del asteroide 
	position.x -= speed * delta
