# Hace que este nodo sea un personaje 2D que puede moverse y colisionar.
extends CharacterBody2D



# Da a este script el nombre de clase global "Centinela".
class_name Centinela

# Velocidad usada para calcular el movimiento hacia el jugador.
var  speed  = 400
# Distancia máxima a la que el centinela detecta al jugador.
const rango_de_deteccion = 200
# Distancia a la que el centinela se detiene porque está dentro del rango de ataque.
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
	# Comprueba la distancia y si el jugador está dentro del campo frontal.
	deteccion(delta)


# Comprueba el rango y si el jugador está en la dirección frontal del centinela.
func deteccion(delta):
	
	# Usa el eje X global del centinela como su dirección frontal.
	var front_centinela = transform.x
	
	# Calcula la dirección normalizada desde el centinela hacia el jugador.
	var player_direction = (player.global_position - global_position).normalized()
	
	# Calcula la distancia entre el centinela y el jugador.
	var distancia = global_position.distance_to(player.global_position) 
	
	# El producto punto indica cuánto apunta el frente del centinela hacia el jugador.
	var vision = front_centinela.dot(player_direction)
	# Muestra el valor de visión actual en la consola de depuración.
	print("vision centinela -> ",vision)
	# Imprime un mensaje fijo de prueba en la consola.
	print("prueba de print ")
	# Si el jugador está dentro del rango de ataque, detiene al centinela.
	if distancia <= rango_ataque:
		velocity = Vector2.ZERO
	# Si el jugador está delante y dentro del rango de detección, lo persigue.
	elif vision > 0.5 and distancia <= rango_de_deteccion:
		# Muestra nuevamente el valor de visión cuando se cumple la condición.
		print("vision centinela -> ",vision)
		
		# Calcula el vector desde el centinela hasta el jugador.
		desplazamiento =  player.global_position - global_position
		# Normaliza la dirección y la escala por delta y por la velocidad.
		velocity = desplazamiento.normalized() * delta * speed
	
	else:
		# Si el jugador está fuera de rango o no está enfrente, detiene al centinela.
		velocity = Vector2.ZERO
	# Aplica el movimiento y gestiona las colisiones.
	move_and_slide()
