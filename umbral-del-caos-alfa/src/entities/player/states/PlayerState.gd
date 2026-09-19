# res://src/entities/player/states/PlayerState.gd
extends State
class_name PlayerState

@export var can_rotate_camera: bool = true
@export var can_move: bool = true
var player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "ERROR: PlayerState debe ser hijo directo o indirecto de un nodo Player.")
