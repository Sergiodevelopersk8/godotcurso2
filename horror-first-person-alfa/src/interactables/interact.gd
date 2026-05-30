# res://src/interactables/interact.gd
extends Area3D
class_name Interact


@export var id : String = "Interact" 

#segun yo obtengo la posicion del objeto
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D


signal isInteract


func action_use():
	# Al llamar a emit(), cualquier cosa conectada se enterará
	isInteract.emit()
	
