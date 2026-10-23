extends CharacterBody3D
class_name Player

var speed = 10.0


func _physics_process(delta: float) -> void:
	
	movimiento()


func movimiento():
	var move_player = Vector2.ZERO
	move_player.x = Input.get_axis("left","right")
	move_player.y = Input.get_axis("up","down")
	var direction = Vector3(move_player.x, 0, move_player.y).normalized()
	
	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x,0,speed)
		velocity.z = move_toward(velocity.z,0,speed)
	
	move_and_slide()
