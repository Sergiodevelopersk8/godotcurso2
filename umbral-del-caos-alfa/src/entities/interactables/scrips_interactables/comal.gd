# Archivo: src/entities/interactables/scrips_interactables/comal.gd
# Descripci?n: Controla un objeto de cocina o interacci?n con el que el jugador puede interactuar.
# Este script forma parte de la l?gica principal del juego y ayuda a entender su comportamiento dentro de Godot.

# Hereda de Interact y reutiliza sus propiedades y comportamiento base.
extends Interact
# Registra Comal como nombre de clase global para usarlo en otros scripts.
class_name Comal


# Expone doneness en el Inspector para configurarlo desde la escena.
@export var doneness : Marker3D #comal
# Crea object_in_comal e inicializa su valor con null.
var object_in_comal: Interact = null



# Ejecuta la l?gica espec?fica de este m?todo dentro del comportamiento del objeto.
func receive_object(object:Interact):
	# Comprueba object_in_comal != null and object_in_comal.get_parent() == self; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if object_in_comal != null and object_in_comal.get_parent() == self:
		# Llama al metodo print para realizar esta accion en este punto.
		print("[Comal] Ya hay algo cocinándose aquí.")
		# Termina el metodo y devuelve false a quien lo llamo.
		return false
	
	
	# Comprueba object.id == "Memela"; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if object.id == "Memela":
		# Guarda en object_in_comal el resultado de object.
		object_in_comal = object
		# emparentamos la memela al comal y la ubicamos en el Marker3D
		object.reparent(self)
		# Guarda en object.global_position el resultado de doneness.global_position.
		object.global_position = doneness.global_position
		# Guarda en object.rotation el resultado de Vector3.ZERO.
		object.rotation = Vector3.ZERO
		#  cuando el objeto sea eliminado o cambie de padre
		# para limpiar la variable automáticamente
		object.tree_exited.connect(_on_object_removed,CONNECT_ONE_SHOT)
		# Llama al metodo print para realizar esta accion en este punto.
		print("[Comal] Se colocó ", object.id, " en el comal.")
		# Termina el metodo y devuelve true a quien lo llamo.
		return true
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Llama al metodo print para realizar esta accion en este punto.
		print("[Comal] No puedes poner ", object.id, " en el comal.")
		# Termina el metodo y devuelve false a quien lo llamo.
		return false


# Ejecuta la l?gica interna del script.
func  _on_object_removed():
	# Guarda en object_in_comal el resultado de null.
	object_in_comal = null
	
