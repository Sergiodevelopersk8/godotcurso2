extends Area2D
class_name Apple

@export var points: int 

func _on_area_entered(area: Area2D) -> void:
	Autoload.update_score(points)
	Signalmanager.score_update.emit()
	queue_free()
