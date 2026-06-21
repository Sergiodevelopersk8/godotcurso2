extends Interact
class_name Bote_de_Salsa

var can_be_loaded = true

 
func _ready() -> void:
	action_use()


func action_use():
	#abrir o cerra 
	super.action_use()
	 
