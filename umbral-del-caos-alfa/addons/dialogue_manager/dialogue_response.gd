## A response to a line of dialogue, usualy attached to a [code]DialogueLine[/code].
class_name DialogueResponse extends RefCounted


## The ID of this response
var id: String

## The internal type of this dialogue object, always set to [code]TYPE_RESPONSE[/code].
var type: String = DMConstants.TYPE_RESPONSE

## The next line ID to use if this response is selected by the player.
var next_id: String = ""

## [code]true[/code] if the condition of this line was met.
var is_allowed: bool = true

## The original condition text.
var condition_as_text: String = ""

## A character (depending on the "characters in responses" behaviour setting).
var character: String = ""

## A dictionary of varialbe replaces for the character name. Generally for internal use only.
var character_replacements: Array[Dictionary] = []

## The prompt for this response.
var text: String = ""

## A dictionary of variable replaces for the text. Generally for internal use only.
var text_replacements: Array[Dictionary] = []

## Any #tags
var tags: PackedStringArray = []

## The key to use for translating the text.
var translation_key: String = ""


# Define el metodo _init para agrupar esta accion del script.
func _init(data: Dictionary = {}) -> void:
	# Comprueba data.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if data.size() > 0:
		# Guarda en id el resultado de data.id.
		id = data.id
		# Guarda en type el resultado de data.type.
		type = data.type
		# Guarda en next_id el resultado de data.next_id.
		next_id = data.next_id
		# Guarda en is_allowed el resultado de data.is_allowed.
		is_allowed = data.is_allowed
		# Guarda en character el resultado de data.character.
		character = data.character
		# Guarda en character_replacements el resultado de data.character_replacements.
		character_replacements = data.character_replacements
		# Guarda en text el resultado de data.text.
		text = data.text
		# Guarda en text_replacements el resultado de data.text_replacements.
		text_replacements = data.text_replacements
		# Guarda en tags el resultado de data.tags.
		tags = data.tags
		# Guarda en translation_key el resultado de data.translation_key.
		translation_key = data.translation_key
		# Guarda en condition_as_text el resultado de data.condition_as_text.
		condition_as_text = data.condition_as_text


# Define el metodo _to_string para agrupar esta accion del script.
func _to_string() -> String:
	# Termina el metodo y devuelve "<DialogueResponse text=\"%s\">" % text a quien lo llamo.
	return "<DialogueResponse text=\"%s\">" % text


# Define el metodo get_tag_value para agrupar esta accion del script.
func get_tag_value(tag_name: String) -> String:
	# Crea wrapped e inicializa su valor con "%s=" % tag_name.
	var wrapped := "%s=" % tag_name
	# Recorre tags y asigna cada elemento a t en cada vuelta.
	for t in tags:
		# Comprueba t.begins_with(wrapped); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if t.begins_with(wrapped):
			# Termina el metodo y devuelve t.replace(wrapped, "").strip_edges() a quien lo llamo.
			return t.replace(wrapped, "").strip_edges()
	# Termina el metodo y devuelve "" a quien lo llamo.
	return ""
