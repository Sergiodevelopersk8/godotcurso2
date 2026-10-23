# Hace que este nodo use el comportamiento de un personaje 2D con movimiento y colisiones.
extends CharacterBody2D

# Velocidad a la que se moverá el personaje.
const SPEED = 300.0

# Referencia al nodo objetivo, asignada desde el Inspector.
@export var objetivo :Node2D

# Se ejecuta en cada fotograma de física.
func _physics_process(delta: float) -> void:
	
	# Guarda la posición global actual del jugador en una variable local.
	var player_posicion = self.global_position
	
	# Calcula el vector desde el jugador hasta el objetivo.
	var desplazamiento =  objetivo.global_position - player_posicion
	
	
	# Convierte el vector en una dirección de longitud 1 y la escala por la velocidad.
	velocity = desplazamiento.normalized()  * SPEED
	# Aplica el movimiento y gestiona las colisiones del personaje.
	move_and_slide()
	
