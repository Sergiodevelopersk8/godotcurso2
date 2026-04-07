extends Enemy
class_name Mushroom

@onready var ray: RayCast2D = $RayCast2D



#func _ready() -> void:
	#sobre escritura de la clase base del enemigo enemy.gd
	#ejecuta el ready primero de la clase base 
	#super._ready()


func _physics_process(delta: float) -> void:
	
	if is_on_wall() or not ray.is_colliding():
		flip()
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.x = -speed 
	move_and_slide()


func flip():
	scale.x *= -1
	speed = -speed
	
