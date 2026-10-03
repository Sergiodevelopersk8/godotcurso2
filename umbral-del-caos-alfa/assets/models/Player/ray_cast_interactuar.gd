# res://assets/models/Player/ray_cast_interactuar.gd
extends RayCast3D
# Registra Interactor3D como nombre de clase global para usarlo en otros scripts.
class_name Interactor3D

# Declara la seinteractable_focused1al interactable_focused; otros nodos pueden conectarse para reaccionar cuando se emita.
signal interactable_focused(description: String)

# Expone player en el Inspector para configurarlo desde la escena.
@export var player: Player
# Expone hand en el Inspector para configurarlo desde la escena.
@export var hand: Marker3D # Inyectamos la mano por Inspector para evitar $"../hand"
# Expone level_objects_container en el Inspector para configurarlo desde la escena.
@export var level_objects_container: Node3D # Asignamos el contenedor de objetos del nivel activo

 
# Crea object_in_hand e inicializa su valor con null.
var object_in_hand: Interact = null

# Actualiza la l?gica del frame actual.
func _process(_delta: float) -> void:
	# Si el RayCast está desactivado (por ejemplo, durante un diálogo), limpiamos el UI focus
	if not is_enabled():
		# Emite la senal interactable_focused con estos datos: "".
		interactable_focused.emit("")
		# Termina el metodo sin devolver un valor.
		return
		
	# Crea current_interactable e inicializa su valor con check_interaction().
	var current_interactable = check_interaction()
	# Llama al metodo handle_input para realizar esta accion en este punto.
	handle_input(current_interactable)


# Ejecuta la l?gica espec?fica de check_interaction dentro del comportamiento del objeto.
# Ejecuta la l?gica espec?fica de este m?todo dentro del comportamiento del objeto.
func check_interaction() -> Interact:
	# Comprueba is_colliding(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if is_colliding():
		# Crea collider e inicializa su valor con get_collider().
		var collider = get_collider()
		# Comprueba collider is Interact; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if collider is Interact:
			# Emite la senal interactable_focused con estos datos: collider.id.
			interactable_focused.emit(collider.id)
			# Termina el metodo y devuelve collider a quien lo llamo.
			return collider # CRUCIAL: Retornamos el objeto detectado
			
	# Emite la senal interactable_focused con estos datos: "".
	interactable_focused.emit("")
	# Termina el metodo y devuelve null a quien lo llamo.
	return null


# Ejecuta la l?gica espec?fica de handle_input dentro del comportamiento del objeto.
# Ejecuta la l?gica espec?fica de este m?todo dentro del comportamiento del objeto.
func handle_input(target_object: Interact) -> void:
	# 1. SOLTAR OBJETO (Tecla asignada a drop)
	if Input.is_action_just_pressed("drop") and object_in_hand:
		# Llama al metodo drop_object para realizar esta accion en este punto.
		drop_object()
		# Termina el metodo sin devolver un valor.
		return

	# 2. DIÁLOGO / INTERACCIÓN CON NPC (Clic Izquierdo)
	if Input.is_action_just_pressed("interact_dialogue") and target_object:
		# Si el NPC/Objeto tiene el método interact() o start_dialogue(), lo invocamos
		if target_object.has_method("interact"):
			# Llama al metodo target_object.interact para realizar esta accion en este punto.
			target_object.interact()
		# Termina el metodo sin devolver un valor.
		return

	# 3. INTERACCIÓN DE OBJETOS / AGARRAR (Tecla E)
	if Input.is_action_just_pressed("interact_object"):
		
		# CASO A: Llevas un objeto en la mano
		if object_in_hand and target_object:
			# Comprueba target_object.has_method("receive_ingredient"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if target_object.has_method("receive_ingredient"):
				# Comprueba target_object.receive_ingredient(object_in_hand); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if target_object.receive_ingredient(object_in_hand):
					# Llama al metodo print para realizar esta accion en este punto.
					print("[Interactor3D] Ingrediente aplicado.")
					# Termina el metodo sin devolver un valor.
					return
			
			# Comprueba target_object.has_method("receive_object"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if target_object.has_method("receive_object"):
				# Comprueba target_object.receive_object(object_in_hand); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if target_object.receive_object(object_in_hand):
					# Guarda en object_in_hand el resultado de null.
					object_in_hand = null
					# Termina el metodo sin devolver un valor.
					return

		# CASO B: Mano vacía y miras un objeto que se puede cargar
		elif not object_in_hand and target_object:
			# Comprueba target_object.can_be_loaded; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if target_object.can_be_loaded:
				# Llama al metodo take_object para realizar esta accion en este punto.
				take_object(target_object)

# Ejecuta la l?gica espec?fica de take_object dentro del comportamiento del objeto.
# Ejecuta la l?gica espec?fica de este m?todo dentro del comportamiento del objeto.
func take_object(object: Interact) -> void:
	# Comprueba not hand; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not hand:
		# Llama al metodo push_error para realizar esta accion en este punto.
		push_error("[Interactor3D] No se ha asignado el nodo 'hand' en el Inspector.")
		# Termina el metodo sin devolver un valor.
		return
		
	# Guarda en object_in_hand el resultado de object.
	object_in_hand = object
	# Método nativo de Godot 4 para cambiar de padre manteniendo/ajustando transformaciones
	object.reparent(hand)
	# Llama al metodo print para realizar esta accion en este punto.
	print("id del objeto -> ",object.id)
	# Guarda en object.position el resultado de object.pos_obj.
	object.position = object.pos_obj
	#object.scale = Vector3.ONE * object.scale_obj

# Ejecuta la l?gica espec?fica de drop_object dentro del comportamiento del objeto.
# Ejecuta la l?gica espec?fica de este m?todo dentro del comportamiento del objeto.
func drop_object() -> void:
	# Comprueba not object_in_hand; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not object_in_hand:
		# Termina el metodo sin devolver un valor.
		return
		
	# Asigna a target_parent la variable level_objects_container, 
	#SI dicha variable no está vacía (null). 
	#DE LO CONTRARIO, asigna la escena actual completa get_tree().current_scene.
	var target_parent = level_objects_container 
	# Comprueba !level_objects_container; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if !level_objects_container:
		# Guarda en target_parent el resultado de get_tree().current_scene.
		target_parent = get_tree().current_scene
	# Llama al metodo object_in_hand.reparent para realizar esta accion en este punto.
	object_in_hand.reparent(target_parent)
	# Guarda en object_in_hand.global_position el resultado de global_position + (-global_transform.basis.z * 1.5).
	object_in_hand.global_position = global_position + (-global_transform.basis.z * 1.5)
	# Suma a object_in_hand.global_position.y el valor 0.4 respecto de su valor anterior.
	object_in_hand.global_position.y += 0.4
	# Llama al metodo object_in_hand.begin_fall para realizar esta accion en este punto.
	object_in_hand.begin_fall()
	# Guarda en object_in_hand el resultado de null.
	object_in_hand = null
