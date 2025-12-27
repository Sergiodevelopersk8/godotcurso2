extends Area2D



func _on_area_entered(area: Area2D) -> void:
	var is_asteroid = area.is_in_group("asteroides")
	
	if is_asteroid:
		
		GameManager.set_is_game_over(true)
		queue_free()
