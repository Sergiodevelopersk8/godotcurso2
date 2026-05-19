extends Control
class_name EndScreen

@onready var return_button: Button = $PanelContainer/MarginContainer/VBoxContainer/ReturnButton
@onready var end_label: Label = $PanelContainer/MarginContainer/VBoxContainer/EndLabel
@onready var score_label: Label = $PanelContainer/MarginContainer/VBoxContainer/ScoreLabel


func _ready() -> void:
	return_button.grab_focus()
	update_label()
	score_label.text = "Your score " + str(Autoload.score)


func update_label():
	if Autoload.lives <= 0:
		end_label.text = "Game Over"
	else:
		end_label.text = "congratulations!"
	score_label.text = "your score: " + str(Autoload.score)


func _on_return_button_pressed() -> void:
	Autoload.restar_game()
