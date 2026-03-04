extends Control

@onready var v_box_container: VBoxContainer = $panel/MarginContainer/VBoxContainer

func _ready() -> void:
	
	
	for level in GameManager.level_launches:
		#creamos un nodo de manera dinamica por script
		var labellevel = Label.new()
		labellevel.text = "level " + str(level) + " : " + str(GameManager.level_launches[level])
		labellevel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v_box_container.add_child(labellevel)
	
	# se crea el boton de manera dinamica para regresar al main
	var boton = Button.new()
	boton.text = "Go Back"
	boton.pressed.connect(_button_pressed)
	v_box_container.add_child(boton)

func _button_pressed():
	GameManager.reset_game()#llama al reset desde el game manager 
