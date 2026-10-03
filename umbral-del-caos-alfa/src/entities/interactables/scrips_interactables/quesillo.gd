# Archivo: src/entities/interactables/scrips_interactables/quesillo.gd
# Descripci?n: Controla un objeto interaccionable relacionado con queso o preparaci?n culinaria.
# Este script forma parte de la l?gica principal del juego y ayuda a entender su comportamiento dentro de Godot.

# Hereda de Interact y reutiliza sus propiedades y comportamiento base.
extends Interact
# Registra Quesillo como nombre de clase global para usarlo en otros scripts.
class_name Quesillo

# Crea velocidad e inicializa su valor con Vector3.ZERO.
var velocidad := Vector3.ZERO
# Obtiene la referencia ray cuando el nodo ya esta listo.
@onready var ray: RayCast3D = $RayCast3D



# Inicializa referencias, conexiones y estado inicial del nodo al arrancar.
func _ready() -> void:
	# Guarda en ray.collision_mask el resultado de 1.
	ray.collision_mask = 1   # la capa de tu suelo
	# Guarda en ray.enabled el resultado de true.
	ray.enabled = true
	# Llama al metodo interact para realizar esta accion en este punto.
	interact()
	# Guarda en can_be_loaded el resultado de true.
	can_be_loaded = true




# Se ejecuta cuando el jugador interact?a con este objeto o NPC.
func interact():
	# Llama a la implementacion heredada de la clase base.
	super.interact()
	# No ejecuta ninguna accion; deja este bloque vacio intencionalmente.
	pass
