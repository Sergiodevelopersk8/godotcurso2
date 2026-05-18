extends Control
class_name StartGameMain


func _on_start_button_pressed() -> void:
	Autoload.load_next_level()
