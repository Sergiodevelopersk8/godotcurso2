# res://src/interactables/interact.gd
extends Area3D
class_name Interact


@export var id : String = "Interact" 

#segun yo obtengo la posicion del objeto
@export var pos_obj:Vector3 = Vector3(0, 0, -0.5)
@export var scale_obj: float = 1.0


signal isInteract


func action_use():
	# Al llamar a emit(), cualquier cosa conectada se enterará
	isInteract.emit()
	
