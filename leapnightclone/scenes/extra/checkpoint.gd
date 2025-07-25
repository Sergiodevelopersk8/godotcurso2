extends Area2D
class_name Checkpoint

#referencia para la animacion
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D


#nodo de body entered
func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	anim_sprite.play("reached")
	#señal desde manager
	EventManager.on_checkpoint_reached.emit()
