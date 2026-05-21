extends Area2D
class_name LevelEnd

@onready var audio_flag: AudioStreamPlayer2D = $Audio_flag



func _on_area_entered(area: Area2D) -> void:
	Signalmanager.level_completed.emit()
	AudioManager.play_sfx(audio_flag,AudioManager.SUCCESS)
	
