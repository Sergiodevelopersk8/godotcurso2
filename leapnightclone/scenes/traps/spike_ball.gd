extends Area2D
class_name SpikeBall

@export var max_speed := 3.5

@export var max_rotation_angle := 40.0


func _process(delta: float) -> void:
	var rotation_factor = sin(Time.get_ticks_msec() / 1000.0 * max_speed)
	rotation_degrees = rotation_factor * max_rotation_angle


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	EventManager.on_played_dead.emit()
