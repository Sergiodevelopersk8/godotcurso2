extends Interact
#class_name TemplateNpcInteract

@export var dialogue : String = ""
@export var mensaje :String = ""
func action_use():
	Global.show_dialogue(id,mensaje)
