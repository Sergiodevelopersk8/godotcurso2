extends Control

@onready var v_box_container: VBoxContainer = $panel/MarginContainer/VBoxContainer

func _ready() -> void:
	
	
	for level in GameManager.level_launches:
		#creamos un nodo de manera dinamica por script
		var labellevel = Label.new()
		labellevel.text = "level " + str(level) + " : " + str(GameManager.level_launches[level])
		labellevel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v_box_container.add_child(labellevel)
