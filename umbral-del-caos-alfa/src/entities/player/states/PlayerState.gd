# res://src/entities/player/states/PlayerState.gd
extends State
# Registra PlayerState como nombre de clase global para usarlo en otros scripts.
class_name PlayerState

# Expone can_rotate_camera en el Inspector para configurarlo desde la escena.
@export var can_rotate_camera: bool = true
# Expone can_move en el Inspector para configurarlo desde la escena.
@export var can_move: bool = true
# Declara player para guardar un dato utilizado por este script.
var player

# Inicializa referencias, conexiones y estado inicial del nodo al arrancar.
func _ready() -> void:
	# Espera a que termine owner.ready antes de continuar.
	await owner.ready
	# Guarda en player el resultado de owner as Player.
	player = owner as Player
	# Llama al metodo assert para realizar esta accion en este punto.
	assert(player != null, "ERROR: PlayerState debe ser hijo directo o indirecto de un nodo Player.")
