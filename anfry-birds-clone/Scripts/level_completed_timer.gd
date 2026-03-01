extends Timer



func _ready() -> void:
	SignalManager.level_completed.connect(_on_level_completed)


func _on_level_completed():
	start()


func _on_timeout() -> void:
	GameManager.load_next_level()
