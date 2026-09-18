extends Interact
class_name Memela

@onready var sphere: MeshInstance3D = $Sphere #memela base 
@onready var memela_roja: MeshInstance3D = $memela_roja
@onready var memela_bandera: MeshInstance3D = $memela_bandera
@onready var memela_bandera_quesillo: MeshInstance3D = $memela_bandera_quesillo
@onready var memela_verde_quesillo: MeshInstance3D = $memela_verde_quesillo

# array para los ingredientes 
var ingredients:Array[String] = []

func _ready() -> void:
	
	can_be_loaded = true
	update_visuals()


func add_ingredients(ingredient_id: String):
	if not ingredients.has(ingredient_id):
		ingredients.append(ingredient_id)
		update_visuals()

func receive_ingredient(object: Interact) -> bool:
	#si el objeto es igual a null regresa false
	if object == null:
		return false
	
	# Verificamos si el ingrediente que sostiene el jugador es válido
	var valid_ingredients = ["Salsa Roja","Salsa Verde","Quesillo"]
	
	if valid_ingredients.has(object.id):
		if ingredients.has(object.id) :
			print("[Memela] Ya tiene ", object.id)
			return false
		add_ingredients(object.id)
		print("[Memela] Se le añadió ", object.id)
		return true
	print("[Memela] No se puede añadir ", object.id)
	return false



func hide_all_meshes() -> void:
	memela_roja.visible = false
	memela_bandera.visible = false
	memela_bandera_quesillo.visible = false
	memela_verde_quesillo.visible = false


func update_visuals():
	hide_all_meshes()
	
	var has_red = ingredients.has("Salsa Roja")
	var has_green = ingredients.has("Salsa Verde")
	var has_cheese = ingredients.has("Quesillo")
	
	# Evaluamos las combinaciones
	if has_red and has_green and has_cheese:
		memela_bandera_quesillo.visible = true
	elif has_red and has_green:
		memela_bandera.visible = true
	elif has_green and has_cheese:
		memela_verde_quesillo.visible = true
	elif has_red:
		memela_roja.visible = true
