extends AnimatedSprite2D
class_name Explosion


func _ready() -> void:
	animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
	queue_free()
