# Ejemplo para el script de NPCIdle o NPCWalk
extends Node
class_name NPCIdle 

# DECLARACIÓN OBLIGATORIA DE LA SEÑAL QUE ESPERA LA MÁQUINA DE ESTADOS
signal transition(state_node, new_state_name: String)

var npc: CharacterBody3D

func setup(owner_npc: CharacterBody3D) -> void:
	npc = owner_npc

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
