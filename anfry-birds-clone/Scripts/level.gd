extends Node2D
@onready var enemys: Node2D = $Enemys

func _ready() -> void:
	
	var total_enemies = enemys.get_child_count()#deveuelve la cantidad de hijos del nodo 
	GameManager.set_enemies_left(total_enemies)
	
