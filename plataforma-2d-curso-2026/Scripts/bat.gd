extends Enemy
class_name Bat

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if not player:
		return
	flip()
	follow_player()



func flip():
	sprite.flip_h = player.position.x > position.x



func follow_player():
	#obtener posicion del player y normalizarlo
	var seguimiento = (player.position - position).normalized()
	#se multiplica el vector por la velocidad del murcielago 
	velocity = seguimiento * speed
	move_and_slide()
