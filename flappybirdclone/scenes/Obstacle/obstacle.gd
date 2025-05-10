extends Node2D
class_name Obstacle



# señal de que so choca el avion
signal on_player_crashed

#velocidad de las montañas
@export var move_speed := 150.0


func _process(delta) :
	# mueve la posicion de la montañas
	position.x -= move_speed * delta


func set_speed(value: float):
	move_speed = value



func _on_area_body_entered (body: Node2D):
	# si el player colisiona con una de las montañas 
	on_player_crashed.emit()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#destruye el objeto que salieron de la escena
	queue_free()
