#Proyecto 1: Movimiento básico
#Un cuadrado que se mueve en 4 direcciones
#Que no salga de la pantalla (límites)
#Que tenga velocidad variable (camina vs corre)
#Sin sprites, solo ColorRect o un nodo con color

extends CharacterBody2D
class_name Player

@export var speed : int 

func _ready() -> void:
	print("posicion inicial: ", position)
	print("tamaño pantalla: ", get_viewport_rect().size)
func _physics_process(delta: float) -> void:
	move_player(delta)
	pantalla_limite()
	


func move_player(delta : float):
	
	var direccion_x = Input.get_axis("izquierda","derecha")
	var direccion_y = Input.get_axis("arriba","abajo")
	var direccion = Vector2(direccion_x,direccion_y)
	
	if direccion != Vector2.ZERO:
		velocity = direccion.normalized() * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()




func pantalla_limite():
	var pantalla = get_viewport_rect().size
	
	position.x = clamp(position.x, 0, pantalla.x)
	position.y = clamp(position.y, 0, pantalla.y)
