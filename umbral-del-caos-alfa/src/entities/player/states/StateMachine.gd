# res://src/entities/player/scripts/StateMachine.gd
extends Node
# Registra StateMachine como nombre de clase global para usarlo en otros scripts.
class_name StateMachine

# Declara la setransitioned1al transitioned; otros nodos pueden conectarse para reaccionar cuando se emita.
signal transitioned(state_name)

# Expone initial_state en el Inspector para configurarlo desde la escena.
@export var initial_state := NodePath()
# Obtiene la referencia state cuando el nodo ya esta listo.
@onready var state: State = get_node(initial_state)
# Declara current_state para guardar un dato utilizado por este script.
var current_state: State

# Inicializa referencias, conexiones y estado inicial del nodo al arrancar.
func _ready() -> void:
	# Espera a que termine owner.ready antes de continuar.
	await owner.ready

	# Recorre get_children() y asigna cada elemento a node_child en cada vuelta.
	for node_child in get_children():
		# Comprueba node_child is State; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if node_child is State:
			# Guarda en node_child.state_machine el resultado de self.
			node_child.state_machine = self

	# Guarda en current_state el resultado de state.
	current_state = state
	# Llama al metodo current_state.enter para realizar esta accion en este punto.
	current_state.enter()

# Actualiza la l?gica del frame actual.
func _process(delta: float) -> void:
	# Comprueba current_state; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if current_state:
		# Llama al metodo current_state.update para realizar esta accion en este punto.
		current_state.update(delta)

# Procesa la f?sica del nodo cada cuadro, como movimiento o colisiones.
func _physics_process(delta: float) -> void:
	# Comprueba current_state; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if current_state:
		# Llama al metodo current_state.physics_update para realizar esta accion en este punto.
		current_state.physics_update(delta)

# Reenv?a el evento de input al estado actual para manejarlo.
func remove_input(event) -> void:
	# Comprueba current_state; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if current_state:
		# Llama al metodo current_state._handled_input para realizar esta accion en este punto.
		current_state._handled_input(event)

# Cambia al estado indicado y ejecuta la transici?n correcta.
func change_state(state_name: String) -> void:
	# Comprueba not has_node(state_name); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not has_node(state_name):
		# Llama al metodo push_warning para realizar esta accion en este punto.
		push_warning("[StateMachine] No existe el estado: %s" % state_name)
		# Termina el metodo sin devolver un valor.
		return

	# Crea new_state e inicializa su valor con get_node(state_name) as State.
	var new_state := get_node(state_name) as State
	# Comprueba new_state == null or new_state == current_state; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if new_state == null or new_state == current_state:
		# Termina el metodo sin devolver un valor.
		return

	# Comprueba current_state; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if current_state:
		# Llama al metodo current_state.exit para realizar esta accion en este punto.
		current_state.exit()

	# Guarda en current_state el resultado de new_state.
	current_state = new_state
	# Guarda en state el resultado de new_state.
	state = new_state          # mantenemos 'state' sincronizado por compatibilidad
	# Llama al metodo current_state.enter para realizar esta accion en este punto.
	current_state.enter()

	# Emite la senal transitioned con estos datos: current_state.name.
	transitioned.emit(current_state.name)

# Alias para que el NPC pueda seguir llamando transition_to()
# Alias para cambiar de estado desde otros scripts del proyecto.
func transition_to(state_name: String) -> void:
	# Llama al metodo change_state para realizar esta accion en este punto.
	change_state(state_name)

# Devuelve el nombre del estado actual para comprobaciones externas.
func get_state() -> String:
	# Termina el metodo y devuelve current_state.name as String if current_state else "" a quien lo llamo.
	return current_state.name as String if current_state else ""
