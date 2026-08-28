extends Node3D
class_name Main


#var PRUEBA = load("res://Dialogues/prueba.dialogue")

const PRUEBA = preload("uid://2wcyu6utaipo")

var dinero : int = 0


func _ready() -> void:
	DialogueManager.show_example_dialogue_balloon(PRUEBA,"start")


func set_dinero(d : int):
	dinero = d

func get_dinero() -> int:
	return dinero
