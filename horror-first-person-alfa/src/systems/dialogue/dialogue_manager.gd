extends Node
#dialogue manager 

signal dialogue_request

signal dialogue_finished


func show_dialogue_data(data:DialogueData):
	
	dialogue_request.emit(data)


func finish_Dialogue():
	
	dialogue_finished.emit()
