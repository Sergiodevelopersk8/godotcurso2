extends CanvasLayer
class_name GameUI

# label del score
@onready var score_label: Label = %ScoreLabel

#menu
@onready var start_menu: Control = %StartMenu




func _ready() -> void:
	score_label.text = "0"


func update_score(value: int):
	#se caseta a string el value
	score_label.text =  str(value)
	
