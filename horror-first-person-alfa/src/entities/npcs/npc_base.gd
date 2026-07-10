extends Interact
class_name NPCBase

enum ClientState {REQUESTING, ASKING, WAITING, ATTENDEDTO, ANGRY }

var current_state: ClientState = ClientState.REQUESTING

@export var waiting_time : float = 45.0 # Segundos antes de que se enoje
@export var current_order : String = "Memela Base"


func _ready() -> void:
	can_be_loaded = false 
	id = "Hablar"        
	

# Esta función la va a llamar tu Player al presionar la E
func action_use():
	super.action_use()
	print("El NPC dice: Quiero una ", current_order)
	# Aquí irá la lógica para abrir su burbuja de diálogo o activar su barra de tiempo
