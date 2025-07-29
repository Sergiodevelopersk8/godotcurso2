extends Area2D
class_name EndCheckpoint

# nos conectamos a la señal de body entered


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	# señal de ganar 
	EventManager.on_game_won.emit()
	
	
