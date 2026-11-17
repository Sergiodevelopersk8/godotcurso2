# res://src/entities/interactables/gabriel_interact.gd
extends Interact
class_name GabrielInteract

# Asignas el HandNode (Marker3D) de Gabriel desde el Inspector
@export var hand_marker: Marker3D 
var memela_recibida: Interact = null

# El Interactor3D llamará a esta función automáticamente al hacer clic con algo en la mano
func receive_object(object: Interact) -> bool:
	var gabriel_npc = get_parent() # Obtenemos a Gabriel
	
	# 1. Validamos si Gabriel ya tiene su memela o si no es un Gabriel válido
	if memela_recibida != null or not gabriel_npc:
		return false
		
	# 2. Comparamos el ID del objeto con el pedido de Gabriel (igual que el Comal compara "Memela")
	if object.id == gabriel_npc.memela_pedido:
		print("object.id -> ",object.id)
		memela_recibida = object
		
		# 3. Emparentamos y posicionamos igual que en el Comal
		object.reparent(self)
		if hand_marker:
			object.global_position = hand_marker.global_position
			object.rotation = Vector3.ZERO
			
		# 4. Avisamos a Gabriel que complete la misión
		if gabriel_npc.has_method("completar_pedido"):
			gabriel_npc.completar_pedido()
			
		return true # ¡Al devolver true, el Interactor3D sabe que debe soltar el objeto de la mano del Player!
	else:
		print("[Gabriel] Eso no es lo que pedí. Yo quería: ", gabriel_npc.memela_pedido)
		return false
