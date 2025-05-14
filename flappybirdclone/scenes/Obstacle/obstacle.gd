extends Node2D
class_name Obstacle



# señal de que so choca el avion
signal on_player_crashed

#señal del scorearea
signal on_player_score


#velocidad de las montañas
@export var move_speed := 150.0

#audio 
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var score_sound: AudioStreamPlayer2D = $ScoreSound





func _process(delta) :
	# mueve la posicion de la montañas
	position.x -= move_speed * delta


#funcion que actualiza la velocidad
func set_speed(value: float):
	move_speed = value



func _on_area_body_entered (body: Node2D):
	# si el player colisiona con una de las montañas 
	on_player_crashed.emit()
	hit_sound.play()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#destruye el objeto que salieron de la escena
	queue_free()


func _on_score_area_body_entered(body: Node2D) -> void:
	on_player_score.emit() 
	score_sound.play()
