extends Control
class_name  GameOver

@onready var final_score_label: Label = %FinalScoreLabel

func _process(delta: float) -> void:
	#si el la funciond del gameover es true muestra la pantalla
	if GameManager.is_game_over:
		visible = true
		final_score_label.text = "You score: " + str(GameManager.score)
