# Hace que este nodo sea un personaje 2D que puede moverse y colisionar.
extends CharacterBody2D



# Da a este script el nombre de clase global "Centinela".
class_name Centinela

# Velocidad usada para calcular el movimiento hacia el jugador.
var  speed  = 400
# Distancia máxima a la que el centinela detecta al jugador.
const rango_de_deteccion = 200
# Distancia a la que el centinela se detiene porque está en rango de ataque.
const rango_ataque = 40
# Referencia al nodo del jugador, asignada desde el Inspector.
@export var player: Player
# Almacena el vector que apunta desde el centinela hacia el jugador.
var desplazamiento

# Se ejecuta en cada fotograma de física.
func _physics_process(delta: float) -> void:
	# Si no se asignó el jugador en el Inspector, termina para evitar errores.
	if player == null:
		return
	# Calcula la distancia al jugador y actualiza el movimiento.
	deteccion(delta)

# Decide si el centinela debe perseguir al jugador o detenerse.
func deteccion(delta):
	# Calcula la distancia entre las posiciones globales del centinela y el jugador.
	var distancia = global_position.distance_to(player.global_position) 
	
	# Dentro del rango de ataque, detiene el movimiento.
	if distancia <= rango_ataque:
		velocity = Vector2.ZERO
	# Dentro del rango de detección y fuera del rango de ataque, se acerca al jugador.
	elif distancia <= rango_de_deteccion:
		# Calcula el vector desde el centinela hasta el jugador.
		desplazamiento =  player.global_position - global_position
		# Normaliza la dirección y la escala por delta y por la velocidad.
		velocity = desplazamiento.normalized() * delta * speed
	else:
		# Fuera del rango de detección, detiene el movimiento.
		velocity = Vector2.ZERO
	# Aplica el movimiento y gestiona las colisiones.
	move_and_slide()
