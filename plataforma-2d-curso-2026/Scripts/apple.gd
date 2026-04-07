extends Area2D
class_name Apple



func _on_area_entered(area: Area2D) -> void:
	queue_free()
