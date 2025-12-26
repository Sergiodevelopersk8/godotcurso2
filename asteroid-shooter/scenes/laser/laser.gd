extends Area2D
class_name Laser

@export var speed = 500.5
@onready var sprite_laser: Sprite2D = $Sprite2D


func _process(delta):
	position.x += speed * delta
	

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("asteroides"):
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
