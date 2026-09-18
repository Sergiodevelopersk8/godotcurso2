# res://assets/models/Player/ray_cast_interactuar.gd
extends RayCast3D
class_name Interactor3D

signal interactable_focused(description: String)

@export var player: Player
@export var hand: Marker3D # Inyectamos la mano por Inspector para evitar $"../hand"
@export var level_objects_container: Node3D # Asignamos el contenedor de objetos del nivel activo

var object_in_hand: Interact = null

func _process(_delta: float) -> void:
	if player and not player.move_and_rotate_player:
		interactable_focused.emit("")
		return
		
	var current_interactable = check_interaction()
	handle_input(current_interactable)

func check_interaction() -> Interact:
	if is_colliding():
		var collider = get_collider()
		if collider is Interact:
			interactable_focused.emit(collider.id)
			return collider # CRUCIAL: Retornamos el objeto detectado
			
	interactable_focused.emit("")
	return null


func handle_input(target_object: Interact) -> void: #target_object detecta que recogemos con su id
	if Input.is_action_just_pressed("drop") and object_in_hand:
		drop_object()
		
	elif Input.is_action_just_pressed("interact"):
		# CASO 1: Llevas un objeto en la mano e intentas entregarlo / combinarlo
		if object_in_hand and target_object:
			
			# si el objeto recibe ingredientes
			if target_object.has_method("receive_ingredient"):
				#variable que agrega el objeto y detecta si el script del objeto tienen el metodo de 
				#recibir ingrediente
				var was_added: bool = target_object.receive_ingredient(object_in_hand)
				if was_added:
					print("[Interactor3D] Ingrediente aplicado con éxito.")
					# si el recipiente de salsa es consumible, aquí harías queue_free()
					
					return # salimos para no ejecutar otras interacciones simultáneas
			
			# ¿El objetivo recibe objetos enteros? (Ej. Comal / Mesa)
			if target_object.has_method("receive_object"):
				var accepted: bool = target_object.receive_object(object_in_hand)
				if accepted:
					object_in_hand = null # Liberamos la mano porque el Comal ya lo sostuvo
					return
					
			print("[Interactor3D] No se puede realizar ninguna acción entre estos objetos.")
			
		# CASO 2: Mano vacía, intentas tomar o interactuar con algo
		elif not object_in_hand and target_object:
			if target_object.can_be_loaded:
				take_object(target_object)
			else:
				target_object.interact()

func take_object(object: Interact) -> void:
	if not hand:
		push_error("[Interactor3D] No se ha asignado el nodo 'hand' en el Inspector.")
		return
		
	object_in_hand = object
	# Método nativo de Godot 4 para cambiar de padre manteniendo/ajustando transformaciones
	object.reparent(hand)
	print("id del objeto -> ",object.id)
	object.position = object.pos_obj
	#object.scale = Vector3.ONE * object.scale_obj

func drop_object() -> void:
	if not object_in_hand:
		return
		
	# Asigna a target_parent la variable level_objects_container, 
	#SI dicha variable no está vacía (null). 
	#DE LO CONTRARIO, asigna la escena actual completa get_tree().current_scene.
	var target_parent = level_objects_container 
	if !level_objects_container:
		target_parent = get_tree().current_scene
	object_in_hand.reparent(target_parent)
	# Posicionamos el objeto 
	global_position + (global_transform.basis.z * -1.5)
	object_in_hand = null
