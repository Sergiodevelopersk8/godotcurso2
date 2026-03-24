extends Camera2D

var player 

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	if not player: # si el jugador no esta en escena retorna
		return
	position = player.position #la camara sigue al jugador
