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


func update_visuals() -> void:
	# 1. Apagamos todos los meshes para limpiar la pantalla
	hide_all_meshes()
	
	# Si no hay ingredientes, mostramos la tortilla base
	if ingredients.is_empty():
		sphere.visible = true
		return
	
	# Verificamos qué ingredientes tiene el array actual
	var has_red = ingredients.has("Salsa Roja")
	var has_green = ingredients.has("Salsa Verde")
	var has_cheese = ingredients.has("Quesillo")
	
	# 2. COMBINACIONES DE 3 INGREDIENTES (Las más específicas primero)
	if has_red and has_green and has_cheese:
		memela_bandera_quesillo.visible = true
	
	# 3. COMBINACIONES DE 2 INGREDIENTES
	elif has_red and has_cheese:
		memela_roja_quesillo.visible = true
	elif has_green and has_cheese:
		memela_verde_quesillo.visible = true
	elif has_red and has_green:
		memela_bandera.visible = true
		
	# 4. INGREDIENTES INDIVIDUALES (Los más generales al final)
	elif has_red:
		memela_roja.visible = true
	elif has_green:
		# memela_verde.visible = true # Descomenta si creas este mesh después
		pass
	elif has_cheese:
		# Si solo tuviera quesillo o la base
		sphere.visible = true
	else:
		sphere.visible = true
