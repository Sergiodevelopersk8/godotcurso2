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
