extends Control
class_name UpgradePanel

#variable de referencia
@onready var level: Label = %Level
@onready var item_name: Label = %ItemName
@onready var start_h_box: HBoxContainer = %StartHBox
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var profit: Label = %Profit
@onready var cook_time: Label = %CookTime
@onready var upgrade_button: Button = %UpgradeButton

#referencia a item que estamos mostrando
var item_ref: Item

#variable que almacena el nivel maximo
var max_value : int

#variable para tener el control actual de la mejora
var current_value: int 

#variable de las estrellas actuales
var current_starts : int = -1

#inicializar el panel
func init_upgrade_panel(item : Item):
	#referencial del item
	item_ref = item
	
	#actualizar mejoras
	item_ref.on_start_reached.connect(_on_start_reached)
	#valor del nivel maximo dle item
	max_value = item.max_level
	
	#Reseteo de la barra de progreso
	progress_bar.value = 0
	
	update_starts()
	

#actualizar valores
func update_starts():
	#actualizar nombre
	item_name.text = item_ref.id
	#actualizar nivel y casteo a string
	level.text = str(item_ref.current_level)
	#nivel actual                                             
	level.text = "Lv . %s" % item_ref.current_level
	#valor del profit
	profit.text = str(item_ref.profit) 
	#valor de cocinado
	cook_time.text = str(item_ref.cook_time)
	#costo de mejora
	upgrade_button.text = str(item_ref.upgrade_cost)

#actualizar barra d eprogreso
func _ready():
	progress_bar.value = current_value / 25.0

func _on_start_reached():
	#reset de barra de progreso
	current_value = 0
	#valor de la estrella
	current_starts += 1
	#referencia para acceder al nodo de la estrella 
	var star: TextureRect = start_h_box.get_child(current_starts)
	#cambiar color
	star.modulate = Color(1,1,1)


func _on_upgrade_button_pressed() -> void:
	SoundManager.play_ui()
	#saber si tenemos las monedas actuales para la mejora
	if GameManager.current_coins < item_ref.upgrade_cost:
		return
	
	#invertir la monedas
	GameManager.current_coins -= item_ref.upgrade_cost
	current_value +=1
	#llamamos a la funcion
	item_ref.update_item()
	update_starts()
	
	
