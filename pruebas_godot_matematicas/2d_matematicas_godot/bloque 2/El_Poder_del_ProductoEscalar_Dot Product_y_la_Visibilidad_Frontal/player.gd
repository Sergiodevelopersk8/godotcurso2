# Hace que este nodo sea un personaje 2D que puede moverse y colisionar.
extends CharacterBody2D
# Permite referirse a este tipo de nodo mediante el nombre global "Player".
class_name Player
# Velocidad usada para calcular el movimiento.
var  speed  = 400
# Distancia máxima del rango de detección.
const rango_de_deteccion = 200
# Distancia que define el rango de ataque.
const rango_ataque = 40
# Referencia al objetivo, asignada desde el Inspector.
@export var objetivo :CharacterBody2D

# Guarda la posición global del jugador cuando se inicializa esta variable.
var player_posicion = self.global_position

# Se ejecuta en cada fotograma de física.
func _physics_process(delta: float) -> void:
	
	# Calcula el vector hacia el objetivo y la distancia a él.
	calcular_desplazamiento()
	# Lee la entrada y actualiza la velocidad del personaje.
	get_input()
	# Mueve al personaje y gestiona sus colisiones.
	move_and_slide()



func calcular_desplazamiento():
	# Resta ambas posiciones globales para obtener el vector hacia el objetivo.
	var vector_desplazamiento = objetivo.global_position - player_posicion
	# Obtiene la longitud del vector, que representa la distancia al objetivo.
	var distancia = vector_desplazamiento.length()

# Alternativa para calcular la distancia usando una función de Godot.
func calcular_desplazamiento_por_funcion_de_godot():
	
	# distance_to devuelve la distancia entre las dos posiciones globales.
	var distancia = global_position.distance_to(objetivo.global_position)
	


func get_input():
	# Obtiene una dirección 2D usando las acciones configuradas en el proyecto.
	var input_direction = Input.get_vector("left", "right", "up", "down")
	# Multiplica la dirección por la velocidad para establecer velocity.
	velocity = input_direction * speed
