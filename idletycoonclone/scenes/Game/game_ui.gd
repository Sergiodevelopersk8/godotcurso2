extends CanvasLayer
class_name GameUI

#referencias de instancias del panel
@onready var coffe_upgrade_panel: UpgradePanel = $CoffeUpgradePanel
@onready var burger_upgrade_panel: UpgradePanel = $BurgerUpgradePanel
@onready var current_coins: Label = %CurrentCoins



#funcion de ready y accedemos al panel
func _ready() -> void:
	#se carga la info dle item correspondiente
	coffe_upgrade_panel.init_upgrade_panel(GameManager.coffe)
	burger_upgrade_panel.init_upgrade_panel(GameManager.burger)

func _process(delta: float) -> void:
	current_coins.text = str(GameManager.current_coins)



func _on_coffe_button_pressed() -> void:
	#reproduce el sonido
	SoundManager.play_ui()
	burger_upgrade_panel.hide()
	#si el panel esta visible
	if coffe_upgrade_panel.visible:
		#cambiamos la visibilidad del panel a falso
		coffe_upgrade_panel.visible = false
	#si no muestra el panel
	else :
		coffe_upgrade_panel.visible = true
	


func _on_burger_button_pressed() -> void:
	#reproduce el sonido
	SoundManager.play_ui()
	coffe_upgrade_panel.hide()
	#si el panel esta visible
	if burger_upgrade_panel.visible:
		#cambiamos la visibilidad del panel a falso
		burger_upgrade_panel.visible = false
	#si no muestra el panel
	else :
		burger_upgrade_panel.visible = true
