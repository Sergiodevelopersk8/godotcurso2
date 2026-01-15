extends CanvasLayer
class_name SettingsMenu

@onready var full_screen_checkbox: CheckBox = $Panel/VBoxContainer/HBoxContainer/FullScreencheckbox
@onready var window_size: OptionButton = $Panel/VBoxContainer/HBoxContainer2/WindowSize
@onready var sf_xslider: HSlider = $Panel/VBoxContainer/HBoxContainer5/SFXslider
@onready var music_sider: HSlider = $Panel/VBoxContainer/HBoxContainer6/MusicSider
@onready var volumen_slider: HSlider = $Panel/VBoxContainer/HBoxContainer7/VolumenSlider


func _ready():
	hide()
	full_screen_checkbox.button_pressed = Save.game_data.fullscreen_on
	_on_full_screencheckbox_pressed()
	sf_xslider.value = Save.game_data.sfx_vol
	music_sider.value = Save.game_data.music_vol
	volumen_slider.value = Save.game_data.master_vol
	window_size.selected = Save.game_data.screen_res
	_on_window_size_item_selected(Save.game_data.screen_res)





func _on_button_pressed() -> void:
	hide()


func _on_full_screencheckbox_pressed() -> void:
	changeScreenResolution()


func changeScreenResolution():
	print("se presiono el boton")
	if full_screen_checkbox.button_pressed:
		print("entro al if")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
		print("entro al else")
	Save.game_data.fullscreen_on = full_screen_checkbox.button_pressed
	Save.save_data()


func _on_window_size_item_selected(index: int) -> void:
	var size : Vector2
	
	match index:
		0:
			size = Vector2(640,360)
		1:
			size = Vector2(1280,720)
		2:
			size = Vector2(1920,1080)
	
	DisplayServer.window_set_size(size)
	Save.game_data.screen_res = index
	Save.save_data()
	

func update_vol(index,vol):
	AudioServer.set_bus_volume_db(index,vol)
	
	match index:
		0:
			Save.game_data.master_vol = vol
		1:
			Save.game_data.sfx_vol = vol
		2:
			Save.game_data.music_vol = vol
	Save.save_data()
	
	



func _on_sf_xslider_value_changed(value: float) -> void:
	update_vol(2,value)


func _on_music_sider_value_changed(value: float) -> void:
	update_vol(1,value)
	pass # Replace with function body.


func _on_volumen_slider_value_changed(value: float) -> void:
	update_vol(0,value)
	pass # Replace with function body.
