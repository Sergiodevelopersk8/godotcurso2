## Tag data associated with a line of dialogue.
class_name DMResolvedTagData extends RefCounted


## The list of tags.
var tags: PackedStringArray = []
## The line with any tag syntax removed.
var text_without_tags: String = ""

# An instance of the compiler [RegEx].
var regex: DMCompilerRegEx = DMCompilerRegEx.new()


# Define el metodo _init para agrupar esta accion del script.
func _init(text: String) -> void:
	# Crea resolved_tags e inicializa su valor con [].
	var resolved_tags: PackedStringArray = []
	# Crea tag_matches e inicializa su valor con regex.TAGS_REGEX.search_all(text).
	var tag_matches: Array[RegExMatch] = regex.TAGS_REGEX.search_all(text)
	# Recorre tag_matches y asigna cada elemento a tag_match en cada vuelta.
	for tag_match in tag_matches:
		# Guarda en text el resultado de text.replace(tag_match.get_string(), "").
		text = text.replace(tag_match.get_string(), "")
		# Crea tags e inicializa su valor con tag_match.get_string().replace("[#", "").replace("]", "").replace(", ", ",").split(",").
		var tags = tag_match.get_string().replace("[#", "").replace("]", "").replace(", ", ",").split(",")
		# Recorre tags y asigna cada elemento a tag en cada vuelta.
		for tag in tags:
			# Guarda en tag el resultado de tag.replace("#", "").
			tag = tag.replace("#", "")
			# Comprueba not tag in resolved_tags; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not tag in resolved_tags:
				# Llama al metodo resolved_tags.append para realizar esta accion en este punto.
				resolved_tags.append(tag)

	# Guarda en tags el resultado de resolved_tags.
	tags = resolved_tags
	# Guarda en text_without_tags el resultado de text.
	text_without_tags = text
