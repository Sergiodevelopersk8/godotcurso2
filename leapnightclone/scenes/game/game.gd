extends Node2D
class_name Game

# referencia al player
@onready var player: Player = $Player

#referencia a label points ui
@onready var points_label: Label = $GameUI/Control/Points_Label



#variable de puntos
var points : int
#variable para el checkpoint
var checkpoint_reached: bool
 
#referencia al maker
@onready var spawn_pos: Marker2D = $SpawnPos

#referencia al maker chckpoint
@onready var checkpoint_respawn_pos: Marker2D = $CheckpointRespawnPos

@onready var game_won_panel: Panel = $GameUI/GameWonPanel



#script de game
#funcion de ready

func _ready() -> void:
	#el eventmanager invoca la funcion de morir y conecta con la
	#funcion de morir
	EventManager.on_played_dead.connect(_on_played_dead)
	#emicion de coleccion de fruta
	EventManager.on_fruit_collected.connect(_on_fruit_collected)
	
	#emicion de checkpoint
	EventManager.on_checkpoint_reached.connect(_on_checkpoint_reached)
	
	#emicion de checkpoint final
	EventManager.on_game_won.connect(_on_game_won)
	




func _on_fruit_collected():
	points += 1
	points_label.text = str(points)

func get_respawn_pos()-> Vector2:
	#si ya se tocco el checkpoint 
	if checkpoint_reached:
		#devuelve la posicion del maker checkpoint
		return checkpoint_respawn_pos.position
	else:
		#devuelve la posicion de maker spawnpos
		return spawn_pos.position


#funcion de muerte
func _on_played_dead():
	#el player invoca su funcion de morir
	player.player_dead()
	#reposicionar el player
	await get_tree().create_timer(0.5).timeout
	var tween := create_tween()
	tween.tween_property(player, "global_position",get_respawn_pos(),0.5)
	tween.tween_callback(player.player_respawn)
	
	
	

#funcion de check point
func _on_checkpoint_reached():
	checkpoint_reached = true

func _on_game_won():
	game_won_panel.show()


func _on_play_button_pressed() -> void:
	get_tree().reload_current_scene()
