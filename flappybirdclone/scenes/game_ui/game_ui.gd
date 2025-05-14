extends CanvasLayer
class_name GameUI

# label del score
@onready var score_label: Label = %ScoreLabel

#menu
@onready var start_menu: Control = %StartMenu

#menu del game over
@onready var game_over_menu: VBoxContainer = %GameOverMenu



func _ready() -> void:
	score_label.text = "0"


func update_score(value: int):
	#se caseta a string el value
	score_label.text =  str(value)
	

func game_over()-> void :
	game_over_menu.show()
	score_label.hide()


func _on_play_button_button_down() -> void:
	get_tree().reload_current_scene()
