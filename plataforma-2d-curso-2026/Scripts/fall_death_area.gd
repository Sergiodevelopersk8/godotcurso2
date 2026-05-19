extends Area2D
class_name FallDeathArea




func _on_area_entered(area: Area2D) -> void:
	Autoload.restart_level()
