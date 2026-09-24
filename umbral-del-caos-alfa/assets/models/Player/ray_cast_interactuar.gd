# res://assets/models/Player/ray_cast_interactuar.gd
extends RayCast3D
class_name Interactor3D

signal interactable_focused(description: String)

@export var player: Player
@export var hand: Marker3D # Inyectamos la mano por Inspector para evitar $"../hand"
@export var level_objects_container: Node3D # Asignamos el contenedor de objetos del nivel activo

var object_in_hand: Interact = null

func _process(_delta: float) -> void:
	# Si el RayCast está desactivado (por ejemplo, durante un diálogo), limpiamos el UI focus
	if not is_enabled():
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


func handle_input(target_object: Interact) -> void:
	# 1. SOLTAR OBJETO (Tecla asignada a drop)
	if Input.is_action_just_pressed("drop") and object_in_hand:
		drop_object()
		return

	# 2. DIÁLOGO / INTERACCIÓN CON NPC (Clic Izquierdo)
	if Input.is_action_just_pressed("interact_dialogue") and target_object:
		# Si el NPC/Objeto tiene el método interact() o start_dialogue(), lo invocamos
		if target_object.has_method("interact"):
			target_object.interact()
		return

	# 3. INTERACCIÓN DE OBJETOS / AGARRAR (Tecla E)
	if Input.is_action_just_pressed("interact_object"):
		# CASO A: Llevas un objeto en la mano
		if object_in_hand and target_object:
			if target_object.has_method("receive_ingredient"):
				if target_object.receive_ingredient(object_in_hand):
					print("[Interactor3D] Ingrediente aplicado.")
					return
			
			if target_object.has_method("receive_object"):
				if target_object.receive_object(object_in_hand):
					object_in_hand = null
					return

		# CASO B: Mano vacía y miras un objeto que se puede cargar
		elif not object_in_hand and target_object:
			if target_object.can_be_loaded:
				take_object(target_object)

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
	object_in_hand.global_position = global_position + (-global_transform.basis.z * 1.5)
	object_in_hand.global_position.y += 0.4
	object_in_hand.begin_fall()
	object_in_hand = null
