extends Interact
class_name NPCCliente1

#variable que acepta el .tres
@export var dialogue_resource : DialogueData 

func _ready() -> void:
	can_be_loaded = false


func interact():
	if dialogue_resource != null:
		DialogueManager.show_dialogue_data(dialogue_resource)
	else:
		print("error no se asigno el dialogue data")
