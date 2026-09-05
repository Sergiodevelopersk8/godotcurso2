# res://src/entities/player/states/State.gd
extends Node
class_name State

# Referencia a la máquina de estados asignada automáticamente por StateMachine.gd
var state_machine: Node = null

# Se ejecuta al ENTRAR al estado (recibe mensajes o parámetros opcionales)
func enter(_msg := {}) -> void:
	pass

# Se ejecuta al SALIR del estado
func exit() -> void:
	pass

# Procesa entradas cuando este estado está activo
func handle_input(_event: InputEvent) -> void:
	pass

# Procesa la lógica por frame (_process) cuando este estado está activo
func update(_delta: float) -> void:
	pass

# Procesa la física (_physics_process) cuando este estado está activo
func physics_update(_delta: float) -> void:
	pass
