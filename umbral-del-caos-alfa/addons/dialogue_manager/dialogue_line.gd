## A line of dialogue returned from [code]DialogueManager[/code].
class_name DialogueLine extends RefCounted


## The ID of this line
var id: String

## The internal type of this dialogue object. One of [code]TYPE_DIALOGUE[/code] or [code]TYPE_MUTATION[/code]
var type: String = DMConstants.TYPE_DIALOGUE

## The next line ID after this line.
var next_id: String = ""

## The character name that is saying this line.
var character: String = ""

## A dictionary of variable replacements fo the character name. Generally for internal use only.
var character_replacements: Array[Dictionary] = []

## The dialogue being spoken.
var text: String = ""

## A dictionary of replacements for the text. Generally for internal use only.
var text_replacements: Array[Dictionary] = []

## The key to use for translating this line.
var translation_key: String = ""

## A map for when and for how long to pause while typing out the dialogue text.
var pauses: Dictionary = {}

## A map for speed changes when typing out the dialogue text.
var speeds: Dictionary = {}

## A map of any mutations to run while typing out the dialogue text.
var inline_mutations: Array[Array] = []

## A list of responses attached to this line of dialogue.
var responses: Array = []

## A list of lines that are spoken simultaneously with this one.
var concurrent_lines: Array[DialogueLine] = []

## A list of any extra game states to check when resolving variables and mutations.
var extra_game_states: Array = []

## How long to show this line before advancing to the next. Either a float (of seconds), [code]"auto"[/code], or [code]null[/code].
var time: String = ""

## Any #tags that were included in the line
var tags: PackedStringArray = []

## The mutation details if this is a mutation line (where [code]type == TYPE_MUTATION[/code]).
var mutation: Dictionary = {}

## The conditions to check before including this line in the flow of dialogue. If failed the line will be skipped over.
var conditions: Dictionary = {}


# Define el metodo _init para agrupar esta accion del script.
func _init(data: Dictionary = {}) -> void:
	# Comprueba data.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if data.size() > 0:
		# Guarda en id el resultado de data.id.
		id = data.id
		# Guarda en next_id el resultado de data.next_id.
		next_id = data.next_id
		# Guarda en type el resultado de data.type.
		type = data.type
		# Guarda en extra_game_states el resultado de data.get("extra_game_states", []).
		extra_game_states = data.get("extra_game_states", [])

		# Compara type con los casos siguientes y ejecuta el que coincida.
		match type:
			# Ejecuta esta instruccion: DMConstants.TYPE_DIALOGUE:.
			DMConstants.TYPE_DIALOGUE:
				# Guarda en character el resultado de data.character.
				character = data.character
				# Guarda en character_replacements el resultado de data.get("character_replacements", [] as Array[Dictionary]).
				character_replacements = data.get("character_replacements", [] as Array[Dictionary])
				# Guarda en text el resultado de data.text.
				text = data.text
				# Guarda en text_replacements el resultado de data.get("text_replacements", [] as Array[Dictionary]).
				text_replacements = data.get("text_replacements", [] as Array[Dictionary])
				# Guarda en translation_key el resultado de data.get("translation_key", data.text).
				translation_key = data.get("translation_key", data.text)
				# Guarda en pauses el resultado de data.get("pauses", {}).
				pauses = data.get("pauses", {})
				# Guarda en speeds el resultado de data.get("speeds", {}).
				speeds = data.get("speeds", {})
				# Guarda en inline_mutations el resultado de data.get("inline_mutations", [] as Array[Array]).
				inline_mutations = data.get("inline_mutations", [] as Array[Array])
				# Guarda en time el resultado de data.get("time", "").
				time = data.get("time", "")
				# Guarda en tags el resultado de data.get("tags", []).
				tags = data.get("tags", [])
				# Guarda en concurrent_lines el resultado de data.get("concurrent_lines", [] as Array[DialogueLine]).
				concurrent_lines = data.get("concurrent_lines", [] as Array[DialogueLine])

			# Ejecuta esta instruccion: DMConstants.TYPE_MUTATION:.
			DMConstants.TYPE_MUTATION:
				# Guarda en mutation el resultado de data.mutation.
				mutation = data.mutation


# Define el metodo _to_string para agrupar esta accion del script.
func _to_string() -> String:
	# Compara type con los casos siguientes y ejecuta el que coincida.
	match type:
		# Ejecuta esta instruccion: DMConstants.TYPE_DIALOGUE:.
		DMConstants.TYPE_DIALOGUE:
			# Termina el metodo y devuelve "<DialogueLine character=\"%s\" text=\"%s\">" % [character, text] a quien lo llamo.
			return "<DialogueLine character=\"%s\" text=\"%s\">" % [character, text]
		# Ejecuta esta instruccion: DMConstants.TYPE_MUTATION:.
		DMConstants.TYPE_MUTATION:
			# Termina el metodo y devuelve "<DialogueLine mutation>" a quien lo llamo.
			return "<DialogueLine mutation>"
	# Termina el metodo y devuelve "" a quien lo llamo.
	return ""


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
