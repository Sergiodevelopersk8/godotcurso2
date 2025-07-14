extends Area2D
class_name Spikes

func _on_body_entered(body: Node2D) -> void:
	EventManager.on_played_dead.emit()
