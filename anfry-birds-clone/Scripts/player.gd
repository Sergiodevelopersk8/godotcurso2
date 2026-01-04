extends RigidBody2D
class_name Palyer

@export var force_multiplayer:float

var is_dragged = false
var start_position 
var force_vector

func _ready() -> void:
	#posicion del player
	start_position = position
	 #Conectar por script a una señal 
	sleeping_state_changed.connect(_on_sleeping_state_changed)


func _physics_process(_delta: float) -> void:
	if is_dragged:
		#develve la posicion del cursor del mouse
		position = get_global_mouse_position()
	
	


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#si se presiona el el boton del 
	if event.is_action_pressed("drag"):
		is_dragged = true
	
	if event.is_action_released("drag"):
		launch()
		

func launch():
	is_dragged = false
	#aqui es para que el player no se quede estatico y tenga gravedad
	freeze = false
	#obtenemos el vector de la posicion del player a la posicion actual 
	force_vector = start_position - position
	
	#aplicar la fuerza instataneamente
	apply_impulse(force_vector * force_multiplayer)


#-----------SEÑALES------------
func _on_sleeping_state_changed():
	#si el player se deja de mover que seria sleep
	queue_free()
