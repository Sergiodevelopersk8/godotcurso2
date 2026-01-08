# res://Scripts/States/StateMachine.gd
extends Node
class_name StateMachine

signal transitioned(state_name) #señal para pasar de estado 

@export var initial_state := NodePath() # ruta del nodo de estado
@onready var state : State = get_node(initial_state) # obtiene el nodo


func _ready() -> void:
	#esperamos a que se cargue el padre
	await owner.ready
	
	#recorremos todos los hijos 
	for child in get_children():
		if child is State:
			#no los asignamos a nosotros 
			child.state_machine = self
		
	
	#accedemos a la funcion de enter del script de state.gd
	state.enter()


#---------OVERRIDES DEL SCRIPT State.gd---------
func _unhandle_input(event):
	state._handled_input(event)

func _process(delta):
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func transition_to(target_state_name : String, msg : Dictionary):
	# si no existe el estado no hagas nada
	if not has_node(target_state_name):
		return
	
	#-------si existe el estado-------- 
	
	state.exit() # sal del estado en el que etemos
	state = get_node(target_state_name) # el estado de ahora es el nuevo estado
	state.enter(msg) # diccionario de mensage 
	emit_signal("transitioned", state.name) # emitimos la señal y pasamos el estado 


func get_state() -> String:
	# obtenemos en que estado estamos 
	return state.name as String 
