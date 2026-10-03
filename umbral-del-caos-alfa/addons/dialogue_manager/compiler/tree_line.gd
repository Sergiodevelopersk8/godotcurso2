## An intermediate representation of a dialogue line before it gets compiled.
class_name DMTreeLine extends RefCounted


## The line number where this dialogue was found (after imported files have had their content imported).
var line_number: int = 0
## The parent [DMTreeLine] of this line.
## This is stored as a Weak Reference so that this RefCounted can elegantly free itself.
## Without it being a Weak Reference, this can easily cause a cyclical reference that keeps this resource alive.
var parent: WeakRef
## The ID of this line.
var id: String
## The type of this line (as a [String] defined in [DMConstants].
var type: String = ""
## Is this line part of a randomised group?
var is_random: bool = false
## The indent count for this line.
var indent: int = 0
## The text of this line.
var text: String = ""
## The child [DMTreeLine]s of this line.
var children: Array[DMTreeLine] = []
## Any doc comments attached to this line.
var notes: String = ""
## Is this a dialogue line that is the child of another dialogue line?
var is_nested_dialogue: bool = false


# Define el metodo _init para agrupar esta accion del script.
func _init(initial_id: String) -> void:
	# Guarda en id el resultado de initial_id.
	id = initial_id


# Define el metodo _to_string para agrupar esta accion del script.
func _to_string() -> String:
	# Crea tabs e inicializa su valor con [].
	var tabs = []
	# Llama al metodo tabs.resize para realizar esta accion en este punto.
	tabs.resize(indent)
	# Llama al metodo tabs.fill para realizar esta accion en este punto.
	tabs.fill("\t")
	# Guarda en tabs el resultado de "".join(tabs).
	tabs = "".join(tabs)

	# Termina el metodo y devuelve tabs.join([tabs + "{\n", a quien lo llamo.
	return tabs.join([tabs + "{\n",
		# Ejecuta esta instruccion: "\tid: %s\n" % [id],.
		"\tid: %s\n" % [id],
		# Ejecuta esta instruccion: "\ttype: %s\n" % [type],.
		"\ttype: %s\n" % [type],
		# Ejecuta esta instruccion: "\tis_random: %s\n" % ["true" if is_random else "false"],.
		"\tis_random: %s\n" % ["true" if is_random else "false"],
		# Ejecuta esta instruccion: "\ttext: %s\n" % [text],.
		"\ttext: %s\n" % [text],
		# Ejecuta esta instruccion: "\tnotes: %s\n" % [notes],.
		"\tnotes: %s\n" % [notes],
		# Ejecuta esta instruccion: "\tchildren: []\n" if children.size() == 0 else "\tchildren: [\n" + ",\n".join(children.map(func(child): return str(child))) + "]\n",.
		"\tchildren: []\n" if children.size() == 0 else "\tchildren: [\n" + ",\n".join(children.map(func(child): return str(child))) + "]\n",
	# Ejecuta esta instruccion: "}"]).
	"}"])
