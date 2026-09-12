extends Interact
class_name Comal


@export var doneness : Marker3D #comal
var object_in_comal: Interact = null



func receive_object(object:Interact):
	if object_in_comal != null and object_in_comal.get_parent() == self:
		print("[Comal] Ya hay algo cocinándose aquí.")
		return false
	
	
	if object.id == "Memela":
		object_in_comal = object
		# Emparentamos la memela al comal y la ubicamos en el Marker3D
		object.reparent(self)
		object.global_position = doneness.global_position
		object.rotation = Vector3.ZERO
		#  cuando el objeto sea eliminado o cambie de padre
		# para limpiar la variable automáticamente
		object.tree_exited.connect(_on_object_removed,CONNECT_ONE_SHOT)
		print("[Comal] Se colocó ", object.id, " en el comal.")
		return true
	else:
		print("[Comal] No puedes poner ", object.id, " en el comal.")
		return false


func  _on_object_removed():
	object_in_comal = null
	
