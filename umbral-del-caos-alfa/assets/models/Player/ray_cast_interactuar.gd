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

func handle_input(target_object: Interact) -> void:
	if Input.is_action_just_pressed("drop") and object_in_hand:
		drop_object()
	elif Input.is_action_just_pressed("interact"):
		if not object_in_hand and target_object:
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
	object.scale = Vector3.ONE * object.scale_obj




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
