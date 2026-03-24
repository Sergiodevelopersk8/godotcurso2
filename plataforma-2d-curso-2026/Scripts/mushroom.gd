extends Enemy

func _physics_process(delta: float) -> void:
	if is_on_wall():
		flip()
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.x = -speed 
	move_and_slide()


func flip():
	scale.x *= -1
	speed = -speed
	
