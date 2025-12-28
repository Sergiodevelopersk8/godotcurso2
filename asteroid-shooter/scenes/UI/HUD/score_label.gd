extends Label


func _process(_delta) -> void:
	text ="SCORE : " + str(GameManager.score)
