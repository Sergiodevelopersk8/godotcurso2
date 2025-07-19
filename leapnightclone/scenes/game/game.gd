extends Node2D
class_name Game

# referencia al player
@onready var player: Player = $Player

#variable de puntos
var points : int

#referencia al maker
@onready var spawn_pos: Marker2D = $SpawnPos





#funcion de ready
func _ready() -> void:
	#el eventmanager invoca la funcion de morir y conecta con la
	#funcion de morir
	EventManager.on_played_dead.connect(_on_played_dead)
	#emicion de coleccion de fruta
	EventManager.on_fruit_collected.connect(_on_fruit_collected)

func _on_fruit_collected():
	points += 1
	print(points)

#funcion de muerte
func _on_played_dead():
	#el player invoca su funcion de morir
	player.player_dead()
	#reposicionar el player
	await get_tree().create_timer(0.5).timeout
	var tween := create_tween()
	tween.tween_property(player, "global_position",spawn_pos.position,0.5)
	tween.tween_callback(player.player_respawn)
