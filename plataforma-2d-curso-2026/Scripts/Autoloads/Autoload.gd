extends Node
#este es un game manager

#estado de jeugos  
enum GameState {MAIN_MENU,END_MENU}

var Menus = {
	1:preload("uid://d4mlfr7pp0px1"), #menu
	2:preload("uid://dxjjim4217ebn")#game over
}

var Levels = {
	1:preload("uid://dhnsfbfj84lcq"), #nivel_1
	2:preload("uid://n63citgsjnbm"),#nivel_2
	}



var current_level = 0


signal state_change()


func load_next_level():
	current_level += 1
	get_tree().change_scene_to_packed(Levels[current_level])
	
