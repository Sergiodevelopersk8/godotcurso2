extends Label


func _process(delta: float) -> void:
	text ="SCORE : " + str(GameManager.score)
