# res://src/entities/player/scripts/StateMachine.gd
# Extiende la clase Node para heredar su funcionalidad básica dentro del árbol de escena.
extends Node

# Registra StateMachine como nombre de clase global para instanciarla o tiparla en otros scripts.
class_name StateMachine

# Declara la señal 'transitioned'; se emite cuando ocurre un cambio de estado pasando el nombre del nuevo estado.
signal transitioned(state_name)


# Expone la ruta del nodo inicial en el Inspector de Godot para configurarlo desde la escena.
@export var initial_state := NodePath()

# Obtiene la referencia al nodo del estado inicial (de tipo State) una vez que el nodo StateMachine está listo.
@onready var state: State = get_node(initial_state)

# Declara la variable 'current_state' para almacenar y gestionar el estado que está activo actualmente.
var current_state: State


# Se ejecuta cuando el nodo y sus hijos entran por primera vez al árbol de escenas.
func _ready() -> void:
	# Espera de forma asíncrona a que el nodo 'owner' (la raíz de la escena actual) complete su propia inicialización.
	await owner.ready
	
	# Recorre todos los nodos hijos directos adjuntos a esta StateMachine.
	for node_child in get_children():
		# Verifica si el nodo hijo es una instancia de la clase 'State'.
		if node_child is State:
			# Asigna esta Máquina de Estados a la propiedad 'state_machine' del nodo hijo para que pueda comunicarse de vuelta.
			node_child.state_machine = self

	# Establece el estado actual como el estado inicial configurado desde el Inspector.
	current_state = state
	
	# Ejecuta la lógica de entrada del estado inicial.
	current_state.enter()


# Se ejecuta en cada fotograma del motor (bucle de renderizado/frame procesado).
func _process(delta: float) -> void:
	# Si hay un estado activo, ejecuta su método de actualización lógica por frame.
	if current_state:
		current_state.update(delta)


# Se ejecuta en cada paso del motor de físicas (paso de tiempo fijo).
func _physics_process(delta: float) -> void:
	# Si hay un estado activo, ejecuta su método de actualización de físicas.
	if current_state:
		current_state.physics_update(delta)


# Cambia el estado actual por uno nuevo especificado por su nombre (nombre del nodo) y pasa datos opcionales en un diccionario.
func change_state(state_name: String, msg: Dictionary = {}) -> void:
	# Verifica si existe un nodo hijo con el nombre del estado solicitado.
	if not has_node(state_name):
		# Muestra una advertencia en la consola si el estado solicitado no existe como nodo hijo y cancela la función.
		push_warning("[StateMachine] No existe el estado: %s" % state_name)
		return

	# Obtiene el nodo con el nombre especificado y lo castea como tipo State.
	var new_state := get_node(state_name) as State
	
	# Cancela la transición si el nodo no es un State válido o si ya nos encontramos en ese mismo estado.
	if new_state == null or new_state == current_state:
		return

	# Si existe un estado actual activo, ejecuta su lógica de salida.
	if current_state:
		current_state.exit()

	# Actualiza la referencia del estado actual al nuevo estado.
	current_state = new_state
	
	# Actualiza la variable 'state' para mantener sincronizadas las referencias.
	state = new_state
	
	# Ejecuta la lógica de entrada del nuevo estado pasando el diccionario con los datos o parámetros iniciales.
	current_state.enter(msg)
	
	# Emite la señal 'transitioned' notificando a otros nodos interesados el nombre del nuevo estado activo.
	transitioned.emit(current_state.name)


# Función 'wrapper' o alias para solicitar una transición llamando internamente a 'change_state'.
func transition_to(state_name: String, msg: Dictionary = {}) -> void:
	change_state(state_name, msg)


# Retorna el nombre del estado actual como String, o una cadena vacía si no hay ningún estado asignado.
func get_state() -> String:
	return current_state.name as String if current_state else ""
