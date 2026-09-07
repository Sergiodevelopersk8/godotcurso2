# res://src/entities/player/states/PlayerState.gd
extends State
class_name PlayerState


var player
## Espera a que el propietario este listo y obtiene la referencia al jugador.
func _ready() -> void:
	#eperamos a que la escena del player se cargue bien 
	await  owner.ready
	player = owner as Player
	assert(player != null, "ERROR: PlayerState debe ser hijo directo o indirecto de un nodo Player.")
