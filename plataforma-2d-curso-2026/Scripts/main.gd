extends Control
class_name StartGameMain


@onready var start_button: Button = $VBoxContainer/StartButton
@onready var high_score_label: Label = $VBoxContainer/HighScoreLabel


func _ready() -> void:
	start_button.grab_focus()
	high_score_label.text = "High score: " + str(Autoload.high_score)

func _on_start_button_pressed() -> void:
	Autoload.load_next_level()
