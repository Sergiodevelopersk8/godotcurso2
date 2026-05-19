extends Node
#este es un game manager



#*******************************Arrays********************************
var Menus = {
	1:preload("uid://d4mlfr7pp0px1"), #menu
	2:preload("uid://dxjjim4217ebn")#game over
}

var Levels = {
	1:preload("uid://dhnsfbfj84lcq"), #nivel_1
	2:preload("uid://n63citgsjnbm"),#nivel_2
	}


#******************************* variables ********************************
var current_level = 0 #cuenta para saber en que nivel estamos
var lives = 3
var score = 0
var high_score = 0
const save_file_path = "user://savefile.save"




#*******************************FUNCIONES********************************

func _ready() -> void:
	load_high_score()

func save_high_score():
	if score > high_score:
		high_score = score
		var save_file = FileAccess.open(save_file_path, FileAccess.WRITE)
		save_file.store_32(high_score)


func load_high_score():
	if FileAccess.file_exists(save_file_path):
		var save_file = FileAccess.open(save_file_path, FileAccess.READ)
		high_score = save_file.get_32()


func update_score(points):
	score += points
	

func load_next_level():
	current_level += 1
	if current_level > Levels.size():
		save_high_score()
		load_scenes(Menus,2)
	else:
		load_scenes(Levels,current_level)
	



func restart_level():
	lives -= 1
	if lives <= 0:
		save_high_score()
		load_scenes(Menus,2)
		return
	load_scenes(Levels,current_level)


func load_scenes(ArrayScene,current_scene):
	get_tree().change_scene_to_packed.call_deferred(ArrayScene[current_scene])
	


func restar_game():
	score = 0
	current_level = 0
	lives = 3
	load_scenes(Menus,1)
