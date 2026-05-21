extends Area2D
class_name Apple

@export var points: int 
@onready var apple_audio: AudioStreamPlayer2D = $Apple_audio
@onready var timer: Timer = $Timer


func play_apple():
	print("entre a reproducir el appple")
	AudioManager.play_sfx(apple_audio,AudioManager.PICKUP)



func _on_area_entered(area: Area2D) -> void:
	Autoload.update_score(points)
	play_apple()
	Signalmanager.score_update.emit()
	timer.start()
	visible = false


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
