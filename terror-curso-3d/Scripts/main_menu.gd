extends CanvasLayer

@onready var settings_menu: CanvasLayer = $SettingsMenu



func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Maps/test_map.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	settings_menu.show()
