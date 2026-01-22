extends Camera2D

var player : Player
var start_pos = Vector2(960,540.0)

func _process(_delta: float) -> void:
	if player == null:
		return
	if player.position.x > position.x:
		position.x = player.position.x


func _on_player_spawner_player_spawned(player_instance) -> void:
	player = player_instance
	position = start_pos
