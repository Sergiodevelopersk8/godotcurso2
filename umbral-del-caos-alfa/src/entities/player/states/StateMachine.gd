# res://src/entities/player/scripts/StateMachine.gd
extends Node
class_name StateMachine


signal transitioned(state_name) #señal para pasar de estado 

@export var initial_state := NodePath() # ruta del nodo de estado
@onready var state : State = get_node(initial_state) # obtiene el nodo


#--------- FUNCIONES DEL SISTEMA -----------
## Asigna la maquina a sus estados hijos e inicia el estado inicial.
func _ready() -> void:
	#esperamos a que se cargue el padre
	await owner.ready
	
	#recorremos todos los hijos 
	for node_child in get_children():
		if node_child is State:
			#no los asignamos a nosotros 
			node_child.state_machine = self
		
	
	#accedemos a la funcion de enter del script de state.gd
	state.enter()

## Ejecuta la actualizacion no fisica del estado activo.
func _process(delta: float) -> void:
	state.update(delta)

## Ejecuta la actualizacion fisica del estado activo.
func _physics_process(delta: float) -> void:
	state.physics_update(delta)



#--------- FUNCIONES PROPIAS -----------


## Reenvia un evento de entrada al estado activo.
func remove_input(event):
	state._handled_input(event)

## Cambia al estado indicado si existe y emite la senal de transicion.
func change_state(current_state_name : String):
	# si no existe el estado no hagas nada
	if not has_node(current_state_name):
		return
	# si  existe el estado
	state.exit()
	state = get_node(current_state_name)
	emit_signal("transitioned", state.name)
	

## Devuelve el nombre del estado activo.
func get_state():
	#obtenemos en que estado estamos
	return state.name as String
