extends Interact
#class_name TemplateNpcInteract

@export var dialogue : String = ""
@export var mensaje :String = ""

func action_use():
	if !Global.is_dialogue_active:
		Global.show_dialogue(id,dialogue)
