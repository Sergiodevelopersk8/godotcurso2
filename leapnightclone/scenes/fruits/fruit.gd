extends Area2D
class_name Fruit

# referencia a animatedsprite2d
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

#variable de coleccion de fruta
var collected := false
 


func _on_body_entered(body: Node2D) -> void:
	 # verificar si recolectamos la fruta.
	if collected:
		return
	# si la estamos recolectando
	collected = true
	anim_sprite.play("collected")
	SoundManager.play_fruit()
	EventManager.on_fruit_collected.emit()
	#esperamos 
	await get_tree().create_timer(0.5).timeout
	#eliminamos la furta de la escena
	queue_free()
