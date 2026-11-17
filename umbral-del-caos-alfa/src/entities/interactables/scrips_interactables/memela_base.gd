# Archivo: src/entities/interactables/scrips_interactables/memela_base.gd
# Descripci?n: Define la base para los objetos de comida o preparaci?n tipo memela.
# Este script forma parte de la l?gica principal del juego y ayuda a entender su comportamiento dentro de Godot.

# Hereda de Interact y reutiliza sus propiedades y comportamiento base.
extends Interact
# Registra Memela como nombre de clase global para usarlo en otros scripts.
class_name Memela

# Obtiene la referencia sphere cuando el nodo ya esta listo.
@onready var sphere: MeshInstance3D = $Sphere #memela base 
# Obtiene la referencia memela_roja cuando el nodo ya esta listo.
@onready var memela_roja: MeshInstance3D = $memela_roja
# Obtiene la referencia memela_bandera cuando el nodo ya esta listo.
@onready var memela_bandera: MeshInstance3D = $memela_bandera
# Obtiene la referencia memela_bandera_quesillo cuando el nodo ya esta listo.
@onready var memela_bandera_quesillo: MeshInstance3D = $memela_bandera_quesillo
# Obtiene la referencia memela_verde_quesillo cuando el nodo ya esta listo.
@onready var memela_verde_quesillo: MeshInstance3D = $memela_verde_quesillo
# Obtiene la referencia memela_roja_quesillo cuando el nodo ya esta listo.
@onready var memela_roja_quesillo: MeshInstance3D = $"memela-roja-quesillo"

# array para los ingredientes 
var ingredients:Array[String] = []

# Variable para saber la receta actual sin alterar la identidad base del objeto
var current_recipe_name: String = "Tortilla base"



# Inicializa referencias, conexiones y estado inicial del nodo al arrancar.
func _ready() -> void:
	
	# Guarda en can_be_loaded el resultado de true.
	can_be_loaded = true
	# Llama al metodo update_visuals para realizar esta accion en este punto.
	update_visuals()


# Ejecuta la l?gica espec?fica de este m?todo dentro del comportamiento del objeto.
func add_ingredients(ingredient_id: String):
	# Comprueba not ingredients.has(ingredient_id); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not ingredients.has(ingredient_id):
		# Llama al metodo ingredients.append para realizar esta accion en este punto.
		ingredients.append(ingredient_id)
		# Llama al metodo update_visuals para realizar esta accion en este punto.
		update_visuals()

# Ejecuta la l?gica espec?fica de este m?todo dentro del comportamiento del objeto.
func receive_ingredient(object: Interact) -> bool:
	#si el objeto es igual a null regresa false
	if object == null:
		# Termina el metodo y devuelve false a quien lo llamo.
		return false
	
	# Verificamos si el ingrediente que sostiene el jugador es válido
	var valid_ingredients = ["Salsa Roja","Salsa Verde","Quesillo"]
	
	# Comprueba valid_ingredients.has(object.id); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if valid_ingredients.has(object.id):
		# Comprueba ingredients.has(object.id) ; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if ingredients.has(object.id) :
			# Llama al metodo print para realizar esta accion en este punto.
			print("[Memela] Ya tiene ", object.id)
			# Termina el metodo y devuelve false a quien lo llamo.
			return false
		# Llama al metodo add_ingredients para realizar esta accion en este punto.
		add_ingredients(object.id)
		# Llama al metodo print para realizar esta accion en este punto.
		print("[Memela] Se le añadió ", object.id)
		# Termina el metodo y devuelve true a quien lo llamo.
		return true
	# Llama al metodo print para realizar esta accion en este punto.
	print("[Memela] No se puede añadir ", object.id)
	# Termina el metodo y devuelve false a quien lo llamo.
	return false



# Ejecuta la lógica específica de este método dentro del comportamiento del objeto.
func hide_all_meshes() -> void:
	# Guarda en memela_roja.visible el resultado de false.
	memela_roja.visible = false
	# Guarda en memela_bandera.visible el resultado de false.
	memela_bandera.visible = false
	# Guarda en memela_bandera_quesillo.visible el resultado de false.
	memela_bandera_quesillo.visible = false
	# Guarda en memela_verde_quesillo.visible el resultado de false.
	memela_verde_quesillo.visible = false
	memela_roja_quesillo.visible = false

# Dentro de memela_base.gd (o tu lógica de interacción con la mesa)
# Sobrescribimos interact respetando la firma original del padre (sin argumentos)
# Sobrescribimos interact respetando la firma original del padre (sin argumentos)
func interact() -> void:
	# Buscamos al jugador directamente mediante su grupo global
	var player = get_tree().get_first_node_in_group("Player")
	
	if player and player.has_method("equip_item"):
		player.equip_item(self)
		print("[Memela] Recogida por el jugador e integrada en la mano.")


func update_visuals() -> void:
	hide_all_meshes()
	
	if ingredients.is_empty():
		sphere.visible = true
		current_recipe_name = "Tortilla base"
		return
	
	var has_red = ingredients.has("Salsa Roja")
	var has_green = ingredients.has("Salsa Verde")
	var has_cheese = ingredients.has("Quesillo")
	
	if has_red and has_green and has_cheese:
		memela_bandera_quesillo.visible = true
		current_recipe_name = "Memela bandera con quesillo"
	elif has_red and has_cheese:
		memela_roja_quesillo.visible = true
		current_recipe_name = "Memela roja con quesillo"
	elif has_green and has_cheese:
		memela_verde_quesillo.visible = true
		current_recipe_name = "Memela verde con quesillo"
	elif has_red and has_green:
		memela_bandera.visible = true
		id = "Memela bandera"
	elif has_red:
		memela_roja.visible = true
		id = "Memela roja"
	elif has_green:
		current_recipe_name = "Memela verde"
	elif has_cheese:
		sphere.visible = true
		current_recipe_name = "Memela con quesillo"
	else:
		sphere.visible = true
		current_recipe_name = "Tortilla base"
