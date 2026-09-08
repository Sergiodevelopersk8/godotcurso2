# res://assets/models/Player/ray_cast_interactuar.gd
extends RayCast3D
class_name Interactor3D

# Señal para notificar al HUD cuando un objeto interactuable entra o sale de foco
@export var hand: Marker3D
@export var player : Player
#nodo de objetos que esta en la escena de nivel 2
@export var objects: Node3D

var object_in_hand = null
signal interactable_focused(description: String)

func _process(_delta: float) -> void:
	interactions()
	check_interaction()


func interactions():
		# Si el player no se debe mover ni rotar, emitimos vacío y cancelamos
	if player and not player.move_and_rotate_player:
		interactable_focused.emit("")
		return
	var see_object = check_interaction()
	if Input.is_action_just_pressed("drop"):
		if object_in_hand != null:
			drop_object(object_in_hand)
	if Input.is_action_just_pressed("interact"):
		if object_in_hand == null:
			if see_object != null:
				if see_object.can_be_loaded:
					take_object(see_object)
				else:
					see_object.interact()



func take_object(object):
	if object_in_hand == null:
		
		#quita el objeto del padre
		#en este caso el padre es un node3d que almacena los obejtos
		#en la escena 
		print("nombre -> ",object.get_parent().name)
		objects.remove_child(object)
		#añada como hijo del marker(hand) el objeto que se muestre 
		hand.add_child(object)
		#establesco la posicion esto es desde la clase interact 
		object.position = object.pos_obj
		#igual para la escala
		object.scale = Vector3.ONE * object.scale_obj
		object_in_hand = object #guardo el obejto
	

func drop_object(object_in_hand):
	
	if object_in_hand != null  :
		hand.remove_child(object_in_hand)
		objects.add_child(object_in_hand) 
		objects.global_position = global_position + (global_transform.basis.z * -1.5)
	
	object_in_hand = null
	pass


func check_interaction():
	if is_colliding():
		var collider = get_collider()
		if collider is Interact:
			# Obtenemos el ID 
			var interact_id = collider.id 
			interactable_focused.emit(interact_id)
			return
			
	interactable_focused.emit("")
