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
	# Calcula la distancia, la orientación relativa y el producto vectorial.
	deteccion(delta)


# Comprueba el rango y la orientación; si el jugador está delante, gira y lo persigue.
func deteccion(delta):
	
	# Usa el eje X global del centinela como su dirección frontal.
	var front_centinela = transform.x
	# Usa el eje Y global; se calcula aquí pero no se utiliza en el resto de la función.
	var back_centinela = transform.y
	# Calcula la dirección normalizada desde el centinela hacia el jugador.
	var player_direction = (player.global_position - global_position).normalized()
	# Calcula el componente Z del producto vectorial 2D para determinar el sentido del giro.
	var cross_2d = ( front_centinela.x * player_direction.y ) - (front_centinela.y * player_direction.x)
	# Declara el factor de suavizado de la velocidad.
	var weight : float
	# Calcula la distancia entre el centinela y el jugador.
	var distancia = global_position.distance_to(player.global_position) 
	
	# El producto punto mide cuánto apunta el frente del centinela hacia el jugador.
	var vision = front_centinela.dot(player_direction)
	# Si el jugador está dentro del rango de ataque, detiene al centinela.
	if distancia <= rango_ataque:
		velocity = Vector2.ZERO
	# Si está enfrente y dentro del rango de detección, gira y lo persigue.
	elif vision > 0.5 and distancia <= rango_de_deteccion:
		# Ajusta la rotación usando el producto vectorial y el tiempo delta.
		rotation += cross_2d * delta
		
		# Calcula el vector desde el centinela hasta el jugador.
		desplazamiento =  player.global_position - global_position
		# Asigna el factor que controla el suavizado.
		weight = 10.0
		# Calcula la velocidad deseada en dirección al jugador.
		var velocity_target = desplazamiento.normalized() * speed
		# Interpola entre la velocidad actual y la deseada para suavizar el movimiento.
		velocity = velocity.lerp(velocity_target, weight * delta)
	
	else:
		# Si el jugador está fuera de rango o no está enfrente, detiene al centinela.
		velocity = Vector2.ZERO
	# Aplica el movimiento y gestiona las colisiones.
	move_and_slide()
