#script de main
extends Node2D

#instancia del spawner
@onready var spawner: Spawner = $Spawner
@onready var player: Player = $Player
@onready var game_ui: GameUI = $GameUI




#alamcena el score
var score: int 



#conectamos el signal del player 
func _on_player_on_game_started() -> void:
	# se espera dos segundos para spawnear
	spawner.timer.start()
	game_ui.start_menu.hide()

func _on_spawner_on_obstacle_crash() -> void:
	player.stop_movement()


func _on_ground_on_player_crash() -> void:
	spawner.stop_obstacles()
	game_ui.game_over()


func _on_spawner_on_player_score() -> void:
	score += 1
	game_ui.update_score(score)
