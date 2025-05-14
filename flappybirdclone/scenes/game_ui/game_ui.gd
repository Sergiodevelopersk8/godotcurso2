extends CanvasLayer
class_name GameUI

# label del score
@onready var score_label: Label = %ScoreLabel

#menu
@onready var start_menu: Control = %StartMenu

#menu del game over
@onready var game_over_menu: VBoxContainer = %GameOverMenu

#imagen y labels de vbox container
@onready var medal_img: TextureRect = %MedalImg
@onready var current_score: Label = %CurrentScore
@onready var heighscore: Label = %Heighscore



#sprite de las medallas
const MEDAL_BRONZE = preload("res://Assets/Sprites/UI/medalBronze.png")
const MEDAL_GOLD = preload("res://Assets/Sprites/UI/medalGold.png")
const MEDAL_SILVER = preload("res://Assets/Sprites/UI/medalSilver.png")





func _ready() -> void:
	score_label.text = "0"


func update_score(value: int):
	#se caseta a string el value
	score_label.text =  str(value)
	

#calcula el score
func calculate_score(score: int, high:int):
	current_score.text = str(score)
	heighscore.text = str(high)
	#muestra la medalla
	if score >= 20:
		medal_img.texture = MEDAL_GOLD
	elif score >= 10:
		medal_img.texture = MEDAL_SILVER
	else :
		medal_img.texture = MEDAL_BRONZE




func game_over()-> void :
	game_over_menu.show()
	score_label.hide()


func _on_play_button_button_down() -> void:
	get_tree().reload_current_scene()
