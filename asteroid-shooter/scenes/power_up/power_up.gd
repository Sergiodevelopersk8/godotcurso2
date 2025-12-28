extends Area2D
class_name PowerUp



func _on_area_entered(area: Area2D) -> void:
	#var asteroides = get_tree().get_first_node_in_group("asteroides")
	var asteroides = get_tree().get_nodes_in_group("asteroides")
	print("colision del area : -> ", area.name)
	if area.is_in_group("player"):
		for asteroide in asteroides:
			asteroide.queue_free()
	queue_free()
