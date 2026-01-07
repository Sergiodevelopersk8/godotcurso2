# res://Scripts/States/PlayerState.gd
extends State
class_name PlayerState

var player : Player


func _ready():
	# owner dueño de todo el script 
	await owner.ready
	#referencia al script del jugador
	player = owner as Player
	
	# si no se carga el rady captura el error
	assert(player != null, "Invalid state node")
