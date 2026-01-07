# res://Scripts/States/State.gd 
extends Node
class_name State

# Estas funciones estan vacias por que
# se van a sobrescribir quien herede esta clase

var state_machine = null

func _handled_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void :
	pass


func physics_update(_delta: float) -> void:
	pass

func enter(_msg := {}) -> void:
	pass

func exit() -> void:
	pass
