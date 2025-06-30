extends Resource
class_name Item

signal on_start_reached
#tipos de item
enum ItemType{
	Coffe,
	Burger
}

@export var star_new_value: int  = 3

@export var id : String
@export var type : ItemType
@export var sprite : Texture2D

@export_group("Cook")
@export var cook_time := 10.0
@export var cook_time_reduce_perc := 0.5

@export_group("Upgrade")
@export var upgrade_cost := 3.0
@export var upgrade_multi := 1.3

@export_group("Profit")
@export var profit := 4.0
@export var profit_multi := 1.2 

var max_level := 75
var current_level := 0

#actualizar item
func update_item():
	#si nuestro nivel actual es mayor o igual que maximo nivel
	if current_level >= max_level:
		return
	
	#mejorar
	current_level += 1
	#actualizar costo de mejora
	upgrade_cost = ceil(upgrade_cost * upgrade_multi)
	profit = ceil(profit * profit_multi)
	#multiplos de 25 si no llega a 75 entra al if
	if current_level % 25 == 0:
		cook_time = ceil(cook_time * cook_time_reduce_perc)
		#aumentar costo de mejora
		upgrade_cost *= 3
		profit *= 3
		#alcanzar una nueva estrella
		on_start_reached.emit()
	
