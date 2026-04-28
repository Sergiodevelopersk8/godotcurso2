#Proyecto 1: Movimiento básico
#Un cuadrado que se mueve en 4 direcciones
#Que no salga de la pantalla (límites)
#Que tenga velocidad variable (camina vs corre)
#Sin sprites, solo ColorRect o un nodo con color

extends CharacterBody2D
class_name Player

@export var speed : int 


func _physics_process(delta: float) -> void:
	move_player(delta)


func move_player(delta : float):
	if global_position.x >= 800.0 or global_position.x <= -233.0 or global_position.y <= -100 or global_position.y >= 400:
		global_position.x = 0.0
		global_position.y = 0.0
		return
	
	var direccion_x = Input.get_axis("izquierda","derecha")
	var direccion_y = Input.get_axis("arriba","abajo")
	var direccion = Vector2(direccion_x,direccion_y)
	
	if direccion != Vector2.ZERO:
		velocity = direccion.normalized() * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	print("posicion de x", global_position.x)
	print("posicion de y", global_position.y)
