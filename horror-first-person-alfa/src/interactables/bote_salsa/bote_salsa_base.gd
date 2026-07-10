extends Interact
class_name Bote_de_Salsa


 
func _ready() -> void:
	action_use()
	can_be_loaded = true


func action_use():
	#abrir o cerra 
	super.action_use()
	 
