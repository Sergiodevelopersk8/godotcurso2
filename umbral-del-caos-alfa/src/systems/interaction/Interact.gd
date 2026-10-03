# Archivo: src/systems/interaction/Interact.gd
# Descripci?n: Base para todos los objetos del mundo que pueden ser interactuados por el jugador.
# Este script forma parte de la l?gica principal del juego y ayuda a entender su comportamiento dentro de Godot.

# Hereda de Area3D y reutiliza sus propiedades y comportamiento base.
extends Area3D
# Registra Interact como nombre de clase global para usarlo en otros scripts.
class_name Interact


# Expone id en el Inspector para configurarlo desde la escena.
@export var id : String = "Interact" 

#segun yo obtengo la posicion del objeto
@export var pos_obj:Vector3 = Vector3(0, 0, -0.5)
# Expone scale_obj en el Inspector para configurarlo desde la escena.
@export var scale_obj: float = 1.0
# Crea can_be_loaded e inicializa su valor con false.
var can_be_loaded: bool = false

# Declara la seisInteract1al isInteract; otros nodos pueden conectarse para reaccionar cuando se emita.
signal isInteract

# Guardamos el estado original para restaurarlo al soltar
var _original_collision_layer: int
# Declara _original_collision_mask para guardar un dato utilizado por este script.
var _original_collision_mask: int

# Crea falling e inicializa su valor con false.
var falling := false
# Crea velocity e inicializa su valor con Vector3.ZERO.
var velocity := Vector3.ZERO
# Crea graviti e inicializa su valor con 12.0.
var graviti := 12.0
# Crea ground_y e inicializa su valor con 0.0.
var ground_y := 0.0

# Activa la ca?da del objeto y reinicia su velocidad.
func begin_fall() -> void:
	# Guarda en falling el resultado de true.
	falling = true
	# Guarda en velocity el resultado de Vector3.ZERO.
	velocity = Vector3.ZERO

# Procesa la f?sica del nodo cada cuadro, como movimiento o colisiones.
func _physics_process(delta: float) -> void:
	# Comprueba not falling; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not falling:
		# Termina el metodo sin devolver un valor.
		return

	# Resta de velocity.y el valor gravity * delta respecto de su valor anterior.
	velocity.y -= gravity * delta
	# Suma a global_position el valor velocity * delta respecto de su valor anterior.
	global_position += velocity * delta

	# Comprueba global_position.y <= ground_y; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if global_position.y <= ground_y:
		# Guarda en global_position.y el resultado de ground_y.
		global_position.y = ground_y
		# Guarda en velocity el resultado de Vector3.ZERO.
		velocity = Vector3.ZERO
		# Guarda en falling el resultado de false.
		falling = false


# Inicializa referencias, conexiones y estado inicial del nodo al arrancar.
func _ready() -> void:
	# Guarda en _original_collision_layer el resultado de collision_layer.
	_original_collision_layer = collision_layer
	# Guarda en _original_collision_mask el resultado de collision_mask.
	_original_collision_mask = collision_mask


# Se ejecuta cuando el jugador interact?a con este objeto o NPC.
func interact():
	# Al llamar a emit(), cualquier cosa conectada se enterará
	isInteract.emit()
