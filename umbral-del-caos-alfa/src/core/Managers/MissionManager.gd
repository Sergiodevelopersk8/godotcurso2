# res://autoloads/mission_manager.gd
extends Node

signal mission_updated(text: String)
signal mission_completed(mission_id: String)

# Diccionario simple de flags de progreso
var flags: Dictionary = {}

# Texto de la misión actual, para mostrar en HUD
var current_mission_text: String = ""

func set_mission(text: String) -> void:
	current_mission_text = text
	mission_updated.emit(text)

func set_flag(flag_name: String, value: bool = true) -> void:
	flags[flag_name] = value

func has_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)

func complete_mission(mission_id: String) -> void:
	set_flag(mission_id + "_completada")
	mission_completed.emit(mission_id)
