# res://src/entities/player/states/State.gd
extends Node
class_name State

# Referencia a la máquina de estados asignada automáticamente por StateMachine.gd
var state_machine: Node = null

## Se ejecuta al entrar al estado y recibe mensajes opcionales.
func enter(_msg := {}) -> void:
	pass

## Se ejecuta al salir del estado actual.
func exit() -> void:
	pass

## Procesa entradas cuando este estado esta activo.
func handle_input(_event: InputEvent) -> void:
	pass

## Procesa la logica por frame cuando este estado esta activo.
func update(_delta: float) -> void:
	pass

## Procesa la fisica cuando este estado esta activo.
func physics_update(_delta: float) -> void:
	pass

## Define el balanceo de camara que pueden personalizar los estados hijos.
func camera_bob(_delta):
	pass
