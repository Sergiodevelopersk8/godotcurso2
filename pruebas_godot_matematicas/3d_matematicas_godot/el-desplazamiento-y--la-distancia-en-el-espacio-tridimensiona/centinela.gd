extends CharacterBody3D
class_name Centinela

# Velocidad ajustada para un entorno 3D (unidades/metros por segundo)
var speed = 5.0

# Rangos ajustados a una escala 3D lógica (ej. metros)
const rango_de_deteccion = 20.0
const rango_ataque = 3.0

# Referencia al nodo del jugador; asegúrate de asignarla en el Inspector
@export var player: CharacterBody3D

func _physics_process(delta: float) -> void:
	# Seguridad por si la ranura del inspector está vacía
	if player == null:
		return
	
	deteccion()
	move_and_slide()

func deteccion():
	# Calculamos la distancia 3D real
	var distancia = global_position.distance_to(player.global_position)
	
	if distancia <= rango_ataque:
		# Demasiado cerca: se detiene para atacar
		velocity = Vector3.ZERO
		print("Estado: Atacando (Distancia: ", distancia, ")")
		
	elif distancia <= rango_de_deteccion:
		# En rango de visión: calcula el vector de desplazamiento (Destino - Origen)
		var desplazamiento = player.global_position - global_position
		velocity = desplazamiento.normalized() * speed
		print("Estado: Persiguiendo (Distancia: ", distancia, ")")
		
	else:
		# Fuera de rango: se detiene
		velocity = Vector3.ZERO
		print("Estado: Fuera de rango")
