# res://src/interactables/interact.gd
extends Area3D
class_name Interact


@export var id : String = "Interact" 

signal isInteract


func action_use():
	# Al llamar a emit(), cualquier cosa conectada se enterará
	isInteract.emit()
	
