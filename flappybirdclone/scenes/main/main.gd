#script de main
extends Node2D

#instancia del spawner
@onready var spawner: Spawner = $Spawner
@onready var player: Player = $Player


#conectamos el signal del player 
func _on_player_on_game_started() -> void:
	# se espera dos segundos para spawnear
	spawner.timer.start()


func _on_obstacle_on_player_crashed() -> void:
	print("colisiono")


func _on_spawner_on_obstacle_crash() -> void:
	player.stop_movement()
