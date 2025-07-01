extends CanvasLayer
class_name GameUI

#referencias de instancias del panel
@onready var coffe_upgrade_panel: UpgradePanel = $CoffeUpgradePanel
@onready var burger_upgrade_panel: UpgradePanel = $BurgerUpgradePanel
@onready var current_coins: Label = %CurrentCoins

#referencia a las tarjetas de la tienda
@onready var shop: Panel = $Shop

@onready var new_cashier_card_1: Panel = %NewCashierCard_1
@onready var new_cashier_button_1: Button = %NewCashierButton_1
@onready var faster_coffe_card: Panel = %FasterCoffeCard
@onready var faster_coffe_button: Button = %FasterCoffeButton
@onready var new_cashier_card_2: Panel = %NewCashierCard_2
@onready var new_cashier_button_2: Button = %NewCashierButton_2
@onready var faster_burger_card: Panel = %FasterBurgerCard
@onready var faster_burger_button: Button = %FasterBurgerButton
@onready var new_cashier_card_3: Panel = %NewCashierCard_3
@onready var new_cashier_button_3: Button = %NewCashierButton_3

#referencia a panel de opciones
@onready var options: Panel = $Options



#variables para modificar precios en el inspector
@export var cashier1_cost:= 50
@export var cashier2_cost:= 500
@export var cashier3_cost:= 5000
@export var faster_coffe_cost := 250
@export var faster_burger_cost := 1000

#funcion de ready y accedemos al panel
func _ready() -> void:
	#se carga la info dle item correspondiente
	coffe_upgrade_panel.init_upgrade_panel(GameManager.coffe)
	burger_upgrade_panel.init_upgrade_panel(GameManager.burger)
	
	new_cashier_button_1.text = GameManager.format_coins(cashier1_cost)
	new_cashier_button_2.text = GameManager.format_coins(cashier2_cost)
	new_cashier_button_3.text = GameManager.format_coins(cashier3_cost)
	
	faster_burger_button.text = GameManager.format_coins(faster_burger_cost)
	faster_coffe_button.text = GameManager.format_coins(faster_coffe_cost)
	

func _process(delta: float) -> void:
	current_coins.text = GameManager.format_coins(GameManager.current_coins)

#abrir o cerrar panel shop
func open_close_shop_panel():
	if shop.visible :
		shop.visible = false
	else:
		shop.visible = true

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


func _on_new_cashier_button_1_pressed() -> void:
	SoundManager.play_ui()
	#validamos si tenemos las monedas suficientes para comparar el cashier
	if GameManager.current_coins >= cashier1_cost:
		#descontar monedas actuales
		GameManager.current_coins -= cashier1_cost
		#señal de crear cashier
		GameManager.on_new_cashier.emit()
		#ocultar la tarjeta de cashier
		new_cashier_card_1.hide()


func _on_faster_coffe_button_pressed() -> void:
	SoundManager.play_ui()
	#validamos si tenemos las monedas suficientes para comparar el cashier
	if GameManager.current_coins >= faster_coffe_cost:
		#descontar monedas actuales
		GameManager.current_coins -= faster_coffe_cost
		#referencia al item coffe y el tiempo de hacerlo se le resta un segundo 
		GameManager.coffe.cook_time = 1
		faster_coffe_card.hide()
	




func _on_new_cashier_button_2_pressed() -> void:
	SoundManager.play_ui()
	#validamos si tenemos las monedas suficientes para comparar el cashier
	if GameManager.current_coins >= cashier2_cost:
		#descontar monedas actuales
		GameManager.current_coins -= cashier2_cost
		#señal de crear cashier
		GameManager.on_new_cashier.emit()
		#ocultar la tarjeta de cashier
		new_cashier_card_2.hide()


func _on_faster_burger_button_pressed() -> void:
	SoundManager.play_ui()
	#validamos si tenemos las monedas suficientes para comparar el cashier
	if GameManager.current_coins >= faster_burger_cost:
		#descontar monedas actuales
		GameManager.current_coins -= faster_burger_cost
		#referencia al item coffe y el tiempo de hacerlo se le resta un segundo 
		GameManager.burger.cook_time = 2
		faster_burger_card.hide()


func _on_new_cashier_button_3_pressed() -> void:
	SoundManager.play_ui()
	#validamos si tenemos las monedas suficientes para comparar el cashier
	if GameManager.current_coins >= cashier3_cost:
		#descontar monedas actuales
		GameManager.current_coins -= cashier3_cost
		#señal de crear cashier
		GameManager.on_new_cashier.emit()
		#ocultar la tarjeta de cashier
		new_cashier_card_3.hide()


func _on_shop_button_pressed() -> void:
	open_close_shop_panel()


func _on_music_slider_value_changed(value: float) -> void:
	var music_index = AudioServer.get_bus_index("Music")
	#accedemos al bus
	AudioServer.set_bus_volume_db(music_index, linear_to_db(value))


func _on_sfx_slider_value_changed(value: float) -> void:
	var sfx_index = AudioServer.get_bus_index("SFX")
	#accedemos al bus
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(value))


func _on_options_button_pressed() -> void:
	if options.visible:
		options.visible = false
	else:
		options.visible = true
