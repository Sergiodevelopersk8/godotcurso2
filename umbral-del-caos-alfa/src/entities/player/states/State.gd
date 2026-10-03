# res://src/entities/player/states/State.gd
extends Node
# Registra State como nombre de clase global para usarlo en otros scripts.
class_name State

# Referencia a la máquina de estados asignada automáticamente por StateMachine.gd
var state_machine: Node = null

## Se ejecuta al entrar al estado y recibe mensajes opcionales.
# Entra a este estado y prepara variables, animaciones o condiciones.
func enter(_msg := {}) -> void:
	# No ejecuta ninguna accion; deja este bloque vacio intencionalmente.
	pass

## Se ejecuta al salir del estado actual.
# Sale del estado actual y limpia recursos o flags asociados.
func exit() -> void:
	# No ejecuta ninguna accion; deja este bloque vacio intencionalmente.
	pass

## Procesa entradas cuando este estado esta activo.
# Ejecuta la l?gica espec?fica de este m?todo dentro del comportamiento del objeto.
func handle_input(_event: InputEvent) -> void:
	# No ejecuta ninguna accion; deja este bloque vacio intencionalmente.
	pass

## Procesa la logica por frame cuando este estado esta activo.
# Actualiza la l?gica del estado activo del personaje cada frame.
func update(_delta: float) -> void:
	# No ejecuta ninguna accion; deja este bloque vacio intencionalmente.
	pass

## Procesa la fisica cuando este estado esta activo.
# Aplica movimiento y f?sicas del estado actual del personaje.
func physics_update(_delta: float) -> void:
	# No ejecuta ninguna accion; deja este bloque vacio intencionalmente.
	pass

## Define el balanceo de camara que pueden personalizar los estados hijos.
# Genera un ligero movimiento de c?mara para reforzar la sensaci?n de caminar o hablar.
func camera_bob(_delta):
	# No ejecuta ninguna accion; deja este bloque vacio intencionalmente.
	pass
