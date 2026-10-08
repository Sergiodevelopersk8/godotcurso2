# res://src/entities/player/states/PlayerState.gd
extends State
# Registra PlayerState como nombre de clase global para usarlo en otros scripts.
class_name PlayerState



# Expone can_rotate_camera en el Inspector para configurarlo desde la escena.
@export var can_rotate_camera: bool = true
# Expone can_move en el Inspector para configurarlo desde la escena.
@export var can_move: bool = true

# Declara player para guardar un dato utilizado por este script.
var player:Player

# Inicializa referencias, conexiones y estado inicial del nodo al arrancar.
func _ready() -> void:
	# Espera a que termine owner.ready antes de continuar.
	await owner.ready
	# Guarda en player el resultado de owner as Player.
	player = owner as Player
	# Llama al metodo assert para realizar esta accion en este punto.
	assert(player != null, "ERROR: PlayerState debe ser hijo directo o indirecto de un nodo Player.")

func enter(_msg := {}) -> void:
	pass

func exit() -> void:
	pass




func update(_delta: float) -> void:
	ManagerCamreaBob.camera_bob_dialogue(player, _delta)

func physics_update(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.friction * delta)
	player.velocity.z = move_toward(player.velocity.z, 0, player.friction * delta)
	player.velocity.y -= player.gravity * delta
	player.move_and_slide()
