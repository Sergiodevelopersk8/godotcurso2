# res://src/entities/player/states/PlayerState.gd
extends State
class_name PlayerState


var player
func _ready() -> void:
	#eperamos a que la escena del player se cargue bien 
	await  owner.ready
	player = owner as Player
	assert(player != null, "ERROR: PlayerState debe ser hijo directo o indirecto de un nodo Player.")
