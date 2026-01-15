extends Node


const SAVEFILE = "res://Save_Data/SAVEFILE.save"

var game_data = {
	"fullscreen_on": true,
	"screen_res":1,
	"sfx_vol": -10,
	"music_vol": -10,
	"master_vol": -10
}

func _ready() -> void:
	load_data()
	print(game_data)




func load_data():
	var file = FileAccess.open(SAVEFILE,FileAccess.READ)
	print(file)
	if file == null:
		save_data()
	else:
		game_data = file.get_var()
	save_data()


func save_data():
	var file = FileAccess.open(SAVEFILE,FileAccess.WRITE)
	file.store_var(game_data)
