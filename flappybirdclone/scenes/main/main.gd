#script de main
extends Node2D
#guardar el dato del score
const SAVE_FILE: String = "user://score.save"


#instancia del spawner
@onready var spawner: Spawner = $Spawner
@onready var player: Player = $Player
@onready var game_ui: GameUI = $GameUI




#alamcena el score
var score: int 
var highscore : int

func _ready() -> void:
	load_higiscore()

#salva el highscore
func save_highscore():
	if score > highscore:
		highscore = score
		#guarda 
		var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
		file.store_32(highscore)

#carga el score alto
func load_higiscore():
	#carga el stroe
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	#nos aseguramos si existe un valor guardado
	if file:
		#carga
		highscore = file.get_32()


#conectamos el signal del player 
func _on_player_on_game_started() -> void:
	# se espera dos segundos para spawnear
	spawner.timer.start()
	game_ui.start_menu.hide()

func _on_spawner_on_obstacle_crash() -> void:
	player.stop_movement()


func _on_ground_on_player_crash() -> void:
	spawner.stop_obstacles()
	game_ui.calculate_score(score,highscore)
	game_ui.game_over()


func _on_spawner_on_player_score() -> void:
	score += 1
	game_ui.update_score(score)
	save_highscore()
