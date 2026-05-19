extends Control
class_name HUD

@onready var lives_label: Label = $MarginContainer/LivesLabel
@onready var score_label: Label = $MarginContainer/ScoreLabel



func _ready() -> void:
	Signalmanager.score_update.connect(_on_score_update)
	lives_label.text = "Lives:  " + str(Autoload.lives)
	_on_score_update()

func _on_score_update():
	score_label.text = "Score: " + str(Autoload.score)
