extends Control
class_name CookBar

#señal de compleado la barra
signal on_cook_completed 


#variable de la barra de progreso del cocinado
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

#funcion de la barra de progreso
func cook_item(time : float):
	var tween := create_tween()
	#anima la barra de progreso de la cocinada
	tween.tween_property(texture_progress_bar,"value", 1.0, time)
	#conectamos y finalizamos
	tween.finished.connect(func(): on_cook_completed.emit())


#funcion de resetear el valor
func reset_bar():
	texture_progress_bar.value = 0
