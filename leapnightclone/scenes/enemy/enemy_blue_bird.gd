extends CharacterBody2D
class_name EnemyBlueBird

#variable para referencia de la clase pathfollow
@export var path : CustomPathFollow 

#referencia de animacion
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D


var dead := false

func _process(delta: float):
	#si path va la derecha es verdadero
	anim_sprite.flip_h = path.direction == 1


func _on_top_area_body_entered(body: Node2D) -> void:
	#colision con el player
	if not body is Player:
		return
	path.can_move = false
	anim_sprite.play("Hit")
	#salto para el player cuando colisiona
	body.velocity.y = -250
	dead = true 
	#sonido
	SoundManager.play_impact()
	#eliminar
	await anim_sprite.animation_finished
	queue_free()


func _on_bottom_area_body_entered(body: Node2D) -> void:
	#colision con el player
	if not body is Player:
		return
	
	if dead: 
		return
	#conectar a la muerte del player
	EventManager.on_played_dead.emit()
