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
# Diccionario que mapea la clave de ingredientes ordenados con su MeshInstance3D
@onready var recipes: Dictionary = {
	"Salsa Roja": memela_roja,
	"Quesillo,Salsa Roja": memela_roja_quesillo,
	"Quesillo,Salsa Verde": memela_verde_quesillo,
	#"Salsa Verde": memela_verde, # Si tienes mesh para verde sola
	"Quesillo,Salsa Bandera": memela_bandera_quesillo,
	"Salsa Bandera": memela_bandera # O la combinación de Roja + Verde
}



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


# Ejecuta la l?gica espec?fica de este método dentro del comportamiento del objeto.
func update_visuals() -> void:
	# 1. Apagamos todos los meshes como siempre
	hide_all_meshes()
	
	# Si no hay ingredientes, nos salimos (o mostramos la tortilla base/sphere)
	if ingredients.is_empty():
		sphere.visible = true
		return
	
	# 2. Creamos una copia de la lista para no alterar el orden original de inserción
	var temp_ingredients: Array[String] = ingredients.duplicate()
	temp_ingredients.sort() # Orden alfabético: ["Quesillo", "Salsa Roja"]
	
	# Convertimos el array a un string separado por comas
	var recipe_key: String = ",".join(temp_ingredients)
	
	# 3. Buscamos en la Tabla de Búsqueda
	if recipes.has(recipe_key):
		var target_mesh: MeshInstance3D = recipes[recipe_key]
		if target_mesh:
			target_mesh.visible = true
			print("[Memela] Receta visual encontrada: ", recipe_key)
	else:
		push_warning("[Memela] No existe una combinación visual para: " + recipe_key)
