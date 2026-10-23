# Hace que este nodo sea un personaje 2D que puede moverse y colisionar.
extends CharacterBody2D

# Da a este script el nombre de clase global "Centinela".
class_name Centinela

# Velocidad usada para mover al centinela.
var  speed  = 400

# Distancia máxima a la que se considera que el jugador está dentro del rango de detección.
const rango_de_deteccion = 200

# Distancia que define el rango de ataque.
const rango_ataque = 40

# Referencia al nodo del jugador; se asigna desde el Inspector.
@export var player: Player

# Guarda el desplazamiento que se usará para calcular la dirección del movimiento.
var desplazamiento

# Se ejecuta en cada fotograma de física.
func _physics_process(delta: float) -> void:
	# Comprueba la distancia al jugador y actualiza el movimiento del centinela.
	deteccion()

	# Mueve el CharacterBody2D según velocity y gestiona las colisiones.
	move_and_slide()

# Calcula la distancia al jugador y decide cómo actualizar el movimiento.
func deteccion():
	# Obtiene la distancia entre el centinela y la posición del jugador.
	var distancia = global_position.distance_to(player.player_posicion) 

	# Si el jugador está a menos de 200 unidades, coloca al centinela en el origen local.
	# Esta condición también incluye las distancias del siguiente "elif".
	if distancia < rango_de_deteccion:	
		position = Vector2.ZERO

	# Intenta mover al centinela cuando la distancia supera el rango de ataque,
	# pero esta condición no se alcanza: cualquier distancia <= rango_de_deteccion
	# ya fue capturada por el "if" anterior.
	elif distancia > rango_ataque and distancia <= rango_de_deteccion:
		# Resta la posición del jugador a la distancia y guarda el resultado.
		# Si player_posicion es Vector2, esta resta mezcla un número y un Vector2.
		desplazamiento = distancia - player.player_posicion
		# Normaliza el desplazamiento y lo escala por la velocidad para obtener velocity.
		velocity = desplazamiento.normalized() * speed
	else:
		# Si no se cumple ninguna condición anterior, detiene el movimiento.
		velocity = Vector2.ZERO

# Se ejecuta una vez cuando el nodo entra en el árbol de la escena.
func _ready() -> void:
	# No hay inicialización configurada por ahora.
	pass # Replace with function body.

# Se ejecuta en cada fotograma; delta representa el tiempo desde el fotograma anterior.
func _process(delta: float) -> void:
	# No hay lógica por fotograma configurada por ahora.
	pass
