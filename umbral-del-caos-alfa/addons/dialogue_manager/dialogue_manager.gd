# Hereda de Node y reutiliza sus propiedades y comportamiento base.
extends Node

# Define DialogueResource con el valor fijo preload("./dialogue_resource.gd").
const DialogueResource = preload("./dialogue_resource.gd")
# Define DialogueLine con el valor fijo preload("./dialogue_line.gd").
const DialogueLine = preload("./dialogue_line.gd")
# Define DialogueResponse con el valor fijo preload("./dialogue_response.gd").
const DialogueResponse = preload("./dialogue_response.gd")

# Define DMConstants con el valor fijo preload("./constants.gd").
const DMConstants = preload("./constants.gd")
# Define Builtins con el valor fijo preload("./utilities/builtins.gd").
const Builtins = preload("./utilities/builtins.gd")
# Define DMSettings con el valor fijo preload("./settings.gd").
const DMSettings = preload("./settings.gd")
# Define DMCompiler con el valor fijo preload("./compiler/compiler.gd").
const DMCompiler = preload("./compiler/compiler.gd")
# Define DMCompilerResult con el valor fijo preload("./compiler/compiler_result.gd").
const DMCompilerResult = preload("./compiler/compiler_result.gd")
# Define DMResolvedLineData con el valor fijo preload("./compiler/resolved_line_data.gd").
const DMResolvedLineData = preload("./compiler/resolved_line_data.gd")


## Emitted when a dialogue balloon is created and dialogue starts
signal dialogue_started(resource: DialogueResource)

## Emitted when a title is encountered while traversing dialogue, usually when jumping from a
## goto line
signal passed_title(title: String)

## Emitted when a line of dialogue is encountered.
signal got_dialogue(line: DialogueLine)

## Emitted when a mutation is encountered.
signal mutated(mutation: Dictionary)

## Emitted when some dialogue has reached the end.
signal dialogue_ended(resource: DialogueResource)

## Used internally.
signal bridge_get_next_dialogue_line_completed(line: DialogueLine)

## Used internally
signal bridge_dialogue_started(resource: DialogueResource)

## Used inernally
signal bridge_mutated()


## The list of globals that dialogue can query
var game_states: Array = []

## Allow dialogue to call singletons
var include_singletons: bool = true

## Allow dialogue to call static methods/properties on classes
var include_classes: bool = true

## Manage translation behaviour
var translation_source: DMConstants.TranslationSource = DMConstants.TranslationSource.Guess

## Used to resolve the current scene. Override if your game manages the current scene itself.
var get_current_scene: Callable = func():
	# Crea current_scene e inicializa su valor con Engine.get_main_loop().current_scene.
	var current_scene: Node = Engine.get_main_loop().current_scene
	# Comprueba current_scene == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if current_scene == null:
		# Guarda en current_scene el resultado de Engine.get_main_loop().root.get_child(Engine.get_main_loop().root.get_child_count() - 1).
		current_scene = Engine.get_main_loop().root.get_child(Engine.get_main_loop().root.get_child_count() - 1)
	# Termina el metodo y devuelve current_scene a quien lo llamo.
	return current_scene

# Crea _has_loaded_autoloads e inicializa su valor con false.
var _has_loaded_autoloads: bool = false
# Crea _autoloads e inicializa su valor con {}.
var _autoloads: Dictionary = {}

# Crea _node_properties e inicializa su valor con [].
var _node_properties: Array = []
# Crea _method_info_cache e inicializa su valor con {}.
var _method_info_cache: Dictionary = {}

# Declara _dotnet_dialogue_manager para guardar un dato utilizado por este script.
var _dotnet_dialogue_manager: RefCounted


# Define el metodo _ready para agrupar esta accion del script.
func _ready() -> void:
	# Cache the known Node2D properties
	_node_properties = ["Script Variables"]
	# Crea temp_node e inicializa su valor con Node2D.new().
	var temp_node: Node2D = Node2D.new()
	# Recorre temp_node.get_property_list() y asigna cada elemento a property en cada vuelta.
	for property in temp_node.get_property_list():
		# Llama al metodo _node_properties.append para realizar esta accion en este punto.
		_node_properties.append(property.name)
	# Llama al metodo temp_node.free para realizar esta accion en este punto.
	temp_node.free()

	# Make the dialogue manager available as a singleton
	if not Engine.has_singleton("DialogueManager"):
		# Llama al metodo Engine.register_singleton para realizar esta accion en este punto.
		Engine.register_singleton("DialogueManager", self)


## Step through lines and run any mutations until we either hit some dialogue or the end of the conversation
func get_next_dialogue_line(resource: DialogueResource, key: String = "", extra_game_states: Array = [], mutation_behaviour: DMConstants.MutationBehaviour = DMConstants.MutationBehaviour.Wait) -> DialogueLine:
	# You have to provide a valid dialogue resource
	if resource == null:
		# Llama al metodo assert para realizar esta accion en este punto.
		assert(false, DMConstants.translate(&"runtime.no_resource"))
	# Comprueba resource.lines.size() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if resource.lines.size() == 0:
		# Llama al metodo assert para realizar esta accion en este punto.
		assert(false, DMConstants.translate(&"runtime.no_content").format({ file_path = resource.resource_path }))

	# Inject any "using" states into the game_states
	for state_name in resource.using_states:
		# Crea autoload e inicializa su valor con Engine.get_main_loop().root.get_node_or_null(state_name).
		var autoload = Engine.get_main_loop().root.get_node_or_null(state_name)
		# Comprueba autoload == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if autoload == null:
			# Llama al metodo printerr para realizar esta accion en este punto.
			printerr(DMConstants.translate(&"runtime.unknown_autoload").format({ autoload = state_name }))
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en extra_game_states el resultado de [autoload] + extra_game_states.
			extra_game_states = [autoload] + extra_game_states

	# Inject "self" into the extra game states.
	extra_game_states = [{ "self": resource }] + extra_game_states

	# Get the line data
	var dialogue: DialogueLine = await get_line(resource, key, extra_game_states)

	# If our dialogue is nothing then we hit the end
	if not _is_valid(dialogue):
		# Llama al metodo dialogue_ended.emit.call_deferred para realizar esta accion en este punto.
		dialogue_ended.emit.call_deferred(resource)
		# Termina el metodo y devuelve null a quien lo llamo.
		return null

	# Run the mutation if it is one
	if dialogue.type == DMConstants.TYPE_MUTATION:
		# Crea actual_next_id e inicializa su valor con dialogue.next_id.split("|")[0].
		var actual_next_id: String = dialogue.next_id.split("|")[0]
		# Compara mutation_behaviour con los casos siguientes y ejecuta el que coincida.
		match mutation_behaviour:
			# Ejecuta esta instruccion: DMConstants.MutationBehaviour.Wait:.
			DMConstants.MutationBehaviour.Wait:
				# Espera a que termine _mutate(dialogue.mutation, extra_game_states) antes de continuar.
				await _mutate(dialogue.mutation, extra_game_states)
			# Ejecuta esta instruccion: DMConstants.MutationBehaviour.DoNotWait:.
			DMConstants.MutationBehaviour.DoNotWait:
				# Llama al metodo _mutate para realizar esta accion en este punto.
				_mutate(dialogue.mutation, extra_game_states)
			# Ejecuta esta instruccion: DMConstants.MutationBehaviour.Skip:.
			DMConstants.MutationBehaviour.Skip:
				# No ejecuta ninguna accion; deja este bloque vacio intencionalmente.
				pass
		# Comprueba actual_next_id in [DMConstants.ID_END_CONVERSATION, DMConstants.ID_NULL, null]; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if actual_next_id in [DMConstants.ID_END_CONVERSATION, DMConstants.ID_NULL, null]:
			# End the conversation
			dialogue_ended.emit.call_deferred(resource)
			# Termina el metodo y devuelve null a quien lo llamo.
			return null
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Termina el metodo y devuelve await get_next_dialogue_line(resource, dialogue.next_id, extra_game_states, mutation_behaviour) a quien lo llamo.
			return await get_next_dialogue_line(resource, dialogue.next_id, extra_game_states, mutation_behaviour)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Emite la senal got_dialogue con estos datos: dialogue.
		got_dialogue.emit(dialogue)
		# Termina el metodo y devuelve dialogue a quien lo llamo.
		return dialogue


## Get a line by its ID
func get_line(resource: DialogueResource, key: String, extra_game_states: Array) -> DialogueLine:
	# Guarda en key el resultado de key.strip_edges().
	key = key.strip_edges()

	# See if we were given a stack instead of just the one key
	var stack: Array = key.split("|")
	# Guarda en key el resultado de stack.pop_front().
	key = stack.pop_front()
	# Crea id_trail e inicializa su valor con "" if stack.size() == 0 else "|" + "|".join(stack).
	var id_trail: String = "" if stack.size() == 0 else "|" + "|".join(stack)

	# Key is blank so just use the first title (or start of file)
	if key == null or key == "":
		# Comprueba resource.first_title.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if resource.first_title.is_empty():
			# Guarda en key el resultado de resource.lines.keys()[0].
			key = resource.lines.keys()[0]
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Guarda en key el resultado de resource.first_title.
			key = resource.first_title

	# See if we just ended the conversation
	if key in [DMConstants.ID_END, DMConstants.ID_NULL, null]:
		# Comprueba stack.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if stack.size() > 0:
			# Termina el metodo y devuelve await get_line(resource, "|".join(stack), extra_game_states) a quien lo llamo.
			return await get_line(resource, "|".join(stack), extra_game_states)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Termina el metodo y devuelve null a quien lo llamo.
			return null
	# Comprueba key == DMConstants.ID_END_CONVERSATION si las condiciones anteriores resultaron falsas.
	elif key == DMConstants.ID_END_CONVERSATION:
		# Termina el metodo y devuelve null a quien lo llamo.
		return null

	# See if it is a title
	if key.begins_with("~ "):
		# Guarda en key el resultado de key.substr(2).
		key = key.substr(2)
	# Comprueba resource.titles.has(key); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if resource.titles.has(key):
		# Guarda en key el resultado de resource.titles.get(key).
		key = resource.titles.get(key)

	# Comprueba key in resource.titles.values(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if key in resource.titles.values():
		# Emite la senal passed_title con estos datos: resource.titles.find_key(key).
		passed_title.emit(resource.titles.find_key(key))

	# Comprueba not resource.lines.has(key); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not resource.lines.has(key):
		# Llama al metodo assert para realizar esta accion en este punto.
		assert(false, DMConstants.translate(&"errors.key_not_found").format({ key = key }))

	# Crea data e inicializa su valor con resource.lines.get(key).
	var data: Dictionary = resource.lines.get(key)

	# If next_id is an expression we need to resolve it.
	if data.has(&"next_id_expression"):
		# Guarda en data.next_id el resultado de await _resolve(data.next_id_expression, extra_game_states).
		data.next_id = await _resolve(data.next_id_expression, extra_game_states)

	# This title key points to another title key so we should jump there instead
	if data.type == DMConstants.TYPE_TITLE and data.next_id in resource.titles.values():
		# Termina el metodo y devuelve await get_line(resource, data.next_id + id_trail, extra_game_states) a quien lo llamo.
		return await get_line(resource, data.next_id + id_trail, extra_game_states)

	# Handle match statements
	if data.type == DMConstants.TYPE_MATCH:
		# Crea value e inicializa su valor con await _resolve_condition_value(data, extra_game_states).
		var value = await _resolve_condition_value(data, extra_game_states)
		# Crea else_cases e inicializa su valor con data.cases.filter(func(s): return s.has("is_else")).
		var else_cases: Array[Dictionary] = data.cases.filter(func(s): return s.has("is_else"))
		# Crea else_case e inicializa su valor con {} if else_cases.size() == 0 else else_cases.front().
		var else_case: Dictionary = {} if else_cases.size() == 0 else else_cases.front()
		# Crea next_id e inicializa su valor con "".
		var next_id: String = ""
		# Recorre data.cases y asigna cada elemento a case en cada vuelta.
		for case in data.cases:
			# Comprueba case == else_case; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if case == else_case:
				# Pasa directamente a la siguiente vuelta del bucle.
				continue
			# Comprueba await _check_case_value(value, case, extra_game_states) si las condiciones anteriores resultaron falsas.
			elif await _check_case_value(value, case, extra_game_states):
				# Guarda en next_id el resultado de case.next_id.
				next_id = case.next_id
				# Termina inmediatamente el bucle actual.
				break
		# Nothing matched so check for else case
		if next_id == "":
			# Comprueba not else_case.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not else_case.is_empty():
				# Guarda en next_id el resultado de else_case.next_id.
				next_id = else_case.next_id
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Guarda en next_id el resultado de data.next_id_after.
				next_id = data.next_id_after
		# Termina el metodo y devuelve await get_line(resource, next_id + id_trail, extra_game_states) a quien lo llamo.
		return await get_line(resource, next_id + id_trail, extra_game_states)

	# Check for weighted random lines.
	if data.has(&"siblings"):
		# Only count siblings that pass their condition (if they have one).
		var successful_siblings: Array = data.siblings.filter(func(sibling): return not sibling.has("condition") or await _check_condition(sibling, extra_game_states))
		# Crea target_weight e inicializa su valor con randf_range(0, successful_siblings.reduce(func(total, sibling): return total + sibling.weight, 0)).
		var target_weight: float = randf_range(0, successful_siblings.reduce(func(total, sibling): return total + sibling.weight, 0))
		# Crea cummulative_weight e inicializa su valor con 0.
		var cummulative_weight: float = 0
		# Recorre successful_siblings y asigna cada elemento a sibling en cada vuelta.
		for sibling in successful_siblings:
			# Comprueba target_weight < cummulative_weight + sibling.weight; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if target_weight < cummulative_weight + sibling.weight:
				# Guarda en data el resultado de resource.lines.get(sibling.id).
				data = resource.lines.get(sibling.id)
				# Termina inmediatamente el bucle actual.
				break
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Suma a cummulative_weight el valor sibling.weight respecto de su valor anterior.
				cummulative_weight += sibling.weight

	# If this line is blank and it's the last line then check for returning snippets.
	if data.type in [DMConstants.TYPE_COMMENT, DMConstants.TYPE_UNKNOWN]:
		# Comprueba data.next_id in [DMConstants.ID_END, DMConstants.ID_NULL, null]; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if data.next_id in [DMConstants.ID_END, DMConstants.ID_NULL, null]:
			# Comprueba stack.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if stack.size() > 0:
				# Termina el metodo y devuelve await get_line(resource, "|".join(stack), extra_game_states) a quien lo llamo.
				return await get_line(resource, "|".join(stack), extra_game_states)
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Termina el metodo y devuelve null a quien lo llamo.
				return null
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Termina el metodo y devuelve await get_line(resource, data.next_id + id_trail, extra_game_states) a quien lo llamo.
			return await get_line(resource, data.next_id + id_trail, extra_game_states)

	# If the line is a random block then go to the start of the block.
	elif data.type == DMConstants.TYPE_RANDOM:
		# Guarda en data el resultado de resource.lines.get(data.next_id).
		data = resource.lines.get(data.next_id)

	# Check conditions.
	elif data.type in [DMConstants.TYPE_CONDITION, DMConstants.TYPE_WHILE]:
		# "else" will have no actual condition.
		if await _check_condition(data, extra_game_states):
			# Termina el metodo y devuelve await get_line(resource, data.next_id + id_trail, extra_game_states) a quien lo llamo.
			return await get_line(resource, data.next_id + id_trail, extra_game_states)
		# Comprueba data.has("next_sibling_id") and not data.next_sibling_id.is_empty() si las condiciones anteriores resultaron falsas.
		elif data.has("next_sibling_id") and not data.next_sibling_id.is_empty():
			# Termina el metodo y devuelve await get_line(resource, data.next_sibling_id + id_trail, extra_game_states) a quien lo llamo.
			return await get_line(resource, data.next_sibling_id + id_trail, extra_game_states)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Termina el metodo y devuelve await get_line(resource, data.next_id_after + id_trail, extra_game_states) a quien lo llamo.
			return await get_line(resource, data.next_id_after + id_trail, extra_game_states)

	# Evaluate jumps.
	elif data.type == DMConstants.TYPE_GOTO:
		# Comprueba data.is_snippet and not id_trail.begins_with("|" + data.next_id_after); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if data.is_snippet and not id_trail.begins_with("|" + data.next_id_after):
			# Guarda en id_trail el resultado de "|" + data.next_id_after + id_trail.
			id_trail = "|" + data.next_id_after + id_trail
		# Termina el metodo y devuelve await get_line(resource, data.next_id + id_trail, extra_game_states) a quien lo llamo.
		return await get_line(resource, data.next_id + id_trail, extra_game_states)

	# Comprueba data.type == DMConstants.TYPE_DIALOGUE si las condiciones anteriores resultaron falsas.
	elif data.type == DMConstants.TYPE_DIALOGUE:
		# Comprueba not data.has(&"id"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if not data.has(&"id"):
			# Guarda en data.id el resultado de key.
			data.id = key

	# Set up a line object.
	var line: DialogueLine = await create_dialogue_line(data, extra_game_states)

	# If the jump point somehow has no content then just end.
	if not line: return null

	# Find any simultaneously said lines.
	if data.has(&"concurrent_lines"):
		# If the list includes this line then it isn't the origin line so ignore it.
		if not data.concurrent_lines.has(data.id):
			# Resolve IDs to their actual lines.
			for line_id: String in data.concurrent_lines:
				# Llama al metodo line.concurrent_lines.append para realizar esta accion en este punto.
				line.concurrent_lines.append(await get_line(resource, line_id, extra_game_states))

	# If we are the first of a list of responses then get the other ones.
	if data.type == DMConstants.TYPE_RESPONSE:
		# Note: For some reason C# has occasional issues with using the responses property directly
		# so instead we use set and get here.
		line.set(&"responses", await _get_responses(data.get(&"responses", []), resource, id_trail, extra_game_states))
		# Termina el metodo y devuelve line a quien lo llamo.
		return line

	# Inject the next node's responses if they have any.
	if resource.lines.has(line.next_id):
		# Crea next_line e inicializa su valor con resource.lines.get(line.next_id).
		var next_line: Dictionary = resource.lines.get(line.next_id)

		# If the response line is marked as a title then make sure to emit the passed_title signal.
		if line.next_id in resource.titles.values():
			# Emite la senal passed_title con estos datos: resource.titles.find_key(line.next_id).
			passed_title.emit(resource.titles.find_key(line.next_id))

		# If the responses come from a snippet then we need to come back here afterwards.
		if next_line.type == DMConstants.TYPE_GOTO and next_line.is_snippet and not id_trail.begins_with("|" + next_line.next_id_after):
			# Guarda en id_trail el resultado de "|" + next_line.next_id_after + id_trail.
			id_trail = "|" + next_line.next_id_after + id_trail

		# If the next line is a title then check where it points to see if that is a set of responses.
		while [DMConstants.TYPE_TITLE, DMConstants.TYPE_GOTO].has(next_line.type) and resource.lines.has(next_line.next_id):
			# Guarda en next_line el resultado de resource.lines.get(next_line.next_id).
			next_line = resource.lines.get(next_line.next_id)

		# Comprueba next_line != null and next_line.type == DMConstants.TYPE_RESPONSE; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if next_line != null and next_line.type == DMConstants.TYPE_RESPONSE:
			# Note: For some reason C# has occasional issues with using the responses property directly
			# so instead we use set and get here.
			line.set(&"responses", await _get_responses(next_line.get(&"responses", []), resource, id_trail, extra_game_states))

	# Guarda en line.next_id el resultado de "|".join(stack) if line.next_id == DMConstants.ID_NULL else line.next_id + id_trail.
	line.next_id = "|".join(stack) if line.next_id == DMConstants.ID_NULL else line.next_id + id_trail
	# Termina el metodo y devuelve line a quien lo llamo.
	return line

## Replace any variables, etc in the text.
func get_resolved_line_data(data: Dictionary, extra_game_states: Array = []) -> DMResolvedLineData:
	# Crea text e inicializa su valor con translate(data).
	var text: String = translate(data)

	# Resolve variables
	for replacement in data.get(&"text_replacements", [] as Array[Dictionary]):
		# Crea value e inicializa su valor con await _resolve(replacement.expression.duplicate(true), extra_game_states).
		var value = await _resolve(replacement.expression.duplicate(true), extra_game_states)
		# Crea index e inicializa su valor con text.find(replacement.value_in_text).
		var index: int = text.find(replacement.value_in_text)
		# Comprueba index == -1; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if index == -1:
			# The replacement wasn't found but maybe the regular quotes have been replaced
			# by special quotes while translating.
			index = text.replace("“", "\"").replace("”", "\"").find(replacement.value_in_text)
		# Comprueba index > -1; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if index > -1:
			# Guarda en text el resultado de text.substr(0, index) + str(value) + text.substr(index + replacement.value_in_text.length()).
			text = text.substr(0, index) + str(value) + text.substr(index + replacement.value_in_text.length())

	# Crea compilation e inicializa su valor con DMCompilation.new().
	var compilation: DMCompilation = DMCompilation.new()

	# Resolve random groups
	for found in compilation.regex.INLINE_RANDOM_REGEX.search_all(text):
		# Crea options e inicializa su valor con found.get_string(&"options").split(&"|").
		var options = found.get_string(&"options").split(&"|")
		# Guarda en text el resultado de text.replace(&"[[%s]]" % found.get_string(&"options"), options[randi_range(0, options.size() - 1)]).
		text = text.replace(&"[[%s]]" % found.get_string(&"options"), options[randi_range(0, options.size() - 1)])

	# Do a pass on the markers to find any conditionals
	var markers: DMResolvedLineData = DMResolvedLineData.new(text)

	# Resolve any conditionals and update marker positions as needed
	if data.type == DMConstants.TYPE_DIALOGUE:
		# Crea resolved_text e inicializa su valor con markers.text.
		var resolved_text: String = markers.text
		# Crea conditionals e inicializa su valor con compilation.regex.INLINE_CONDITIONALS_REGEX.search_all(resolved_text).
		var conditionals: Array[RegExMatch] = compilation.regex.INLINE_CONDITIONALS_REGEX.search_all(resolved_text)
		# Crea replacements e inicializa su valor con [].
		var replacements: Array = []
		# Recorre conditionals y asigna cada elemento a conditional en cada vuelta.
		for conditional in conditionals:
			# Crea condition_raw e inicializa su valor con conditional.strings[conditional.names.condition].
			var condition_raw: String = conditional.strings[conditional.names.condition]
			# Crea body e inicializa su valor con conditional.strings[conditional.names.body].
			var body: String = conditional.strings[conditional.names.body]
			# Crea body_else e inicializa su valor con "".
			var body_else: String = ""
			# Comprueba &"[else]" in body; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if &"[else]" in body:
				# Crea bits e inicializa su valor con body.split(&"[else]").
				var bits = body.split(&"[else]")
				# Guarda en body el resultado de bits[0].
				body = bits[0]
				# Guarda en body_else el resultado de bits[1].
				body_else = bits[1]
			# Crea condition e inicializa su valor con compilation.extract_condition("if " + condition_raw, false, 0).
			var condition: Dictionary = compilation.extract_condition("if " + condition_raw, false, 0)
			# If the condition fails then use the else of ""
			if not await _check_condition({ condition = condition }, extra_game_states):
				# Guarda en body el resultado de body_else.
				body = body_else
			# Llama al metodo replacements.append para realizar esta accion en este punto.
			replacements.append({
				# Guarda en start el resultado de conditional.get_start(),.
				start = conditional.get_start(),
				# Guarda en end el resultado de conditional.get_end(),.
				end = conditional.get_end(),
				# Guarda en string el resultado de conditional.get_string(),.
				string = conditional.get_string(),
				# Guarda en body el resultado de body.
				body = body
			# Ejecuta esta instruccion: }).
			})

		# Recorre range(replacements.size() - 1, -1, -1) y asigna cada elemento a i en cada vuelta.
		for i in range(replacements.size() - 1, -1, -1):
			# Crea r e inicializa su valor con replacements[i].
			var r: Dictionary = replacements[i]
			# Guarda en resolved_text el resultado de resolved_text.substr(0, r.start) + r.body + resolved_text.substr(r.end, 9999).
			resolved_text = resolved_text.substr(0, r.start) + r.body + resolved_text.substr(r.end, 9999)
			# Move any other markers now that the text has changed
			var offset: int = r.end - r.start - r.body.length()
			# Recorre [&"pauses", &"speeds", &"time"] y asigna cada elemento a key en cada vuelta.
			for key in [&"pauses", &"speeds", &"time"]:
				# Ejecuta esta instruccion: if markers.get(key) == null: continue.
				if markers.get(key) == null: continue
				# Crea marker e inicializa su valor con markers.get(key).
				var marker = markers.get(key)
				# Crea next_marker e inicializa su valor con {}.
				var next_marker: Dictionary = {}
				# Recorre marker y asigna cada elemento a index en cada vuelta.
				for index in marker:
					# Comprueba index < r.start; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if index < r.start:
						# Ejecuta esta instruccion: next_marker[index] = marker[index].
						next_marker[index] = marker[index]
					# Comprueba index > r.start si las condiciones anteriores resultaron falsas.
					elif index > r.start:
						# Ejecuta esta instruccion: next_marker[index - offset] = marker[index].
						next_marker[index - offset] = marker[index]
				# Llama al metodo markers.set para realizar esta accion en este punto.
				markers.set(key, next_marker)
			# Crea mutations e inicializa su valor con markers.mutations.
			var mutations: Array[Array] = markers.mutations
			# Crea next_mutations e inicializa su valor con [].
			var next_mutations: Array[Array] = []
			# Recorre mutations y asigna cada elemento a mutation en cada vuelta.
			for mutation in mutations:
				# Crea index e inicializa su valor con mutation[0].
				var index = mutation[0]
				# Comprueba index < r.start; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if index < r.start:
					# Llama al metodo next_mutations.append para realizar esta accion en este punto.
					next_mutations.append(mutation)
				# Comprueba index > r.start si las condiciones anteriores resultaron falsas.
				elif index > r.start:
					# Llama al metodo next_mutations.append para realizar esta accion en este punto.
					next_mutations.append([index - offset, mutation[1]])
			# Guarda en markers.mutations el resultado de next_mutations.
			markers.mutations = next_mutations

		# Guarda en markers.text el resultado de resolved_text.
		markers.text = resolved_text

	# Termina el metodo y devuelve markers a quien lo llamo.
	return markers


## Replace any variables, etc in the character name
func get_resolved_character(data: Dictionary, extra_game_states: Array = []) -> String:
	# Crea character e inicializa su valor con data.get(&"character", "").
	var character: String = data.get(&"character", "")

	# Resolve variables
	for replacement in data.get(&"character_replacements", []):
		# Crea value e inicializa su valor con await _resolve(replacement.expression.duplicate(true), extra_game_states).
		var value = await _resolve(replacement.expression.duplicate(true), extra_game_states)
		# Crea index e inicializa su valor con character.find(replacement.value_in_text).
		var index: int = character.find(replacement.value_in_text)
		# Comprueba index > -1; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if index > -1:
			# Guarda en character el resultado de character.substr(0, index) + str(value) + character.substr(index + replacement.value_in_text.length()).
			character = character.substr(0, index) + str(value) + character.substr(index + replacement.value_in_text.length())

	# Resolve random groups
	var random_regex: RegEx = RegEx.new()
	# Llama al metodo random_regex.compile para realizar esta accion en este punto.
	random_regex.compile("\\[\\[(?<options>.*?)\\]\\]")
	# Recorre random_regex.search_all(character) y asigna cada elemento a found en cada vuelta.
	for found in random_regex.search_all(character):
		# Crea options e inicializa su valor con found.get_string(&"options").split("|").
		var options = found.get_string(&"options").split("|")
		# Guarda en character el resultado de character.replace("[[%s]]" % found.get_string(&"options"), options[randi_range(0, options.size() - 1)]).
		character = character.replace("[[%s]]" % found.get_string(&"options"), options[randi_range(0, options.size() - 1)])

	# Termina el metodo y devuelve character a quien lo llamo.
	return character


## Generate a dialogue resource on the fly from some text
func create_resource_from_text(text: String) -> Resource:
	# Crea result e inicializa su valor con DMCompiler.compile_string(text, "").
	var result: DMCompilerResult = DMCompiler.compile_string(text, "")

	# Comprueba result.errors.size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if result.errors.size() > 0:
		# Llama al metodo printerr para realizar esta accion en este punto.
		printerr(DMConstants.translate(&"runtime.errors").format({ count = result.errors.size() }))
		# Recorre result.errors y asigna cada elemento a error en cada vuelta.
		for error in result.errors:
			# Llama al metodo printerr para realizar esta accion en este punto.
			printerr(DMConstants.translate(&"runtime.error_detail").format({
				# Guarda en line el resultado de error.line_number + 1,.
				line = error.line_number + 1,
				# Guarda en message el resultado de DMConstants.get_error_message(error.error).
				message = DMConstants.get_error_message(error.error)
			# Ejecuta esta instruccion: })).
			}))
		# Llama al metodo assert para realizar esta accion en este punto.
		assert(false, DMConstants.translate(&"runtime.errors_see_details").format({ count = result.errors.size() }))

	# Crea resource e inicializa su valor con DialogueResource.new().
	var resource: DialogueResource = DialogueResource.new()
	# Guarda en resource.using_states el resultado de result.using_states.
	resource.using_states = result.using_states
	# Guarda en resource.titles el resultado de result.titles.
	resource.titles = result.titles
	# Guarda en resource.first_title el resultado de result.first_title.
	resource.first_title = result.first_title
	# Guarda en resource.character_names el resultado de result.character_names.
	resource.character_names = result.character_names
	# Guarda en resource.lines el resultado de result.lines.
	resource.lines = result.lines
	# Guarda en resource.raw_text el resultado de text.
	resource.raw_text = text

	# Termina el metodo y devuelve resource a quien lo llamo.
	return resource


#region Balloon helpers


## Show the example balloon
func show_example_dialogue_balloon(resource: DialogueResource, title: String = "", extra_game_states: Array = []) -> CanvasLayer:
	# Crea balloon e inicializa su valor con load(_get_example_balloon_path()).instantiate().
	var balloon: Node = load(_get_example_balloon_path()).instantiate()
	# Llama al metodo _start_balloon.call_deferred para realizar esta accion en este punto.
	_start_balloon.call_deferred(balloon, resource, title, extra_game_states)
	# Termina el metodo y devuelve balloon a quien lo llamo.
	return balloon


## Show the configured dialogue balloon
func show_dialogue_balloon(resource: DialogueResource, title: String = "", extra_game_states: Array = []) -> Node:
	# Crea balloon_path e inicializa su valor con DMSettings.get_setting(DMSettings.BALLOON_PATH, _get_example_balloon_path()).
	var balloon_path: String = DMSettings.get_setting(DMSettings.BALLOON_PATH, _get_example_balloon_path())
	# Comprueba not ResourceLoader.exists(balloon_path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not ResourceLoader.exists(balloon_path):
		# Guarda en balloon_path el resultado de _get_example_balloon_path().
		balloon_path = _get_example_balloon_path()
	# Termina el metodo y devuelve show_dialogue_balloon_scene(balloon_path, resource, title, extra_game_states) a quien lo llamo.
	return show_dialogue_balloon_scene(balloon_path, resource, title, extra_game_states)


## Show a given balloon scene
func show_dialogue_balloon_scene(balloon_scene, resource: DialogueResource, title: String = "", extra_game_states: Array = []) -> Node:
	# Comprueba balloon_scene is String; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if balloon_scene is String:
		# Guarda en balloon_scene el resultado de load(balloon_scene).
		balloon_scene = load(balloon_scene)
	# Comprueba balloon_scene is PackedScene; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if balloon_scene is PackedScene:
		# Guarda en balloon_scene el resultado de balloon_scene.instantiate().
		balloon_scene = balloon_scene.instantiate()

	# Crea balloon e inicializa su valor con balloon_scene.
	var balloon: Node = balloon_scene
	# Llama al metodo _start_balloon.call_deferred para realizar esta accion en este punto.
	_start_balloon.call_deferred(balloon, resource, title, extra_game_states)
	# Termina el metodo y devuelve balloon a quien lo llamo.
	return balloon


## Resolve a static line ID to an actual line ID
func static_id_to_line_id(resource: DialogueResource, static_id: String) -> String:
	# Crea ids e inicializa su valor con static_id_to_line_ids(resource, static_id).
	var ids = static_id_to_line_ids(resource, static_id)
	# Ejecuta esta instruccion: if ids.size() == 0: return "".
	if ids.size() == 0: return ""
	# Termina el metodo y devuelve ids[0] a quien lo llamo.
	return ids[0]


## Resolve a static line ID to any actual line IDs that match
func static_id_to_line_ids(resource: DialogueResource, static_id: String) -> PackedStringArray:
	# Termina el metodo y devuelve resource.lines.values().filter(func(l): return l.get(&"translation_key", "") == static_id).map(func(l): return l.id) a quien lo llamo.
	return resource.lines.values().filter(func(l): return l.get(&"translation_key", "") == static_id).map(func(l): return l.id)


# Call "start" on the given balloon.
func _start_balloon(balloon: Node, resource: DialogueResource, title: String, extra_game_states: Array) -> void:
	# Llama al metodo get_current_scene.call para realizar esta accion en este punto.
	get_current_scene.call().add_child(balloon)

	# Comprueba balloon.has_method(&"start"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if balloon.has_method(&"start"):
		# Llama al metodo balloon.start para realizar esta accion en este punto.
		balloon.start(resource, title, extra_game_states)
	# Comprueba balloon.has_method(&"Start") si las condiciones anteriores resultaron falsas.
	elif balloon.has_method(&"Start"):
		# Llama al metodo balloon.Start para realizar esta accion en este punto.
		balloon.Start(resource, title, extra_game_states)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Llama al metodo assert para realizar esta accion en este punto.
		assert(false, DMConstants.translate(&"runtime.dialogue_balloon_missing_start_method"))

	# Emite la senal dialogue_started con estos datos: resource.
	dialogue_started.emit(resource)
	# Emite la senal bridge_dialogue_started con estos datos: resource.
	bridge_dialogue_started.emit(resource)


# Get the path to the example balloon
func _get_example_balloon_path() -> String:
	# Crea is_small_window e inicializa su valor con ProjectSettings.get_setting("display/window/size/viewport_width") < 400.
	var is_small_window: bool = ProjectSettings.get_setting("display/window/size/viewport_width") < 400
	# Crea balloon_path e inicializa su valor con "/example_balloon/small_example_balloon.tscn" if is_small_window else "/example_balloon/example_balloon.tscn".
	var balloon_path: String = "/example_balloon/small_example_balloon.tscn" if is_small_window else "/example_balloon/example_balloon.tscn"
	# Termina el metodo y devuelve get_script().resource_path.get_base_dir() + balloon_path a quien lo llamo.
	return get_script().resource_path.get_base_dir() + balloon_path


#endregion

#region dotnet bridge


# Define el metodo _get_dotnet_dialogue_manager para agrupar esta accion del script.
func _get_dotnet_dialogue_manager() -> RefCounted:
	# Comprueba not is_instance_valid(_dotnet_dialogue_manager); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not is_instance_valid(_dotnet_dialogue_manager):
		# Guarda en _dotnet_dialogue_manager el resultado de load(get_script().resource_path.get_base_dir() + "/DialogueManager.cs").new().
		_dotnet_dialogue_manager = load(get_script().resource_path.get_base_dir() + "/DialogueManager.cs").new()
	# Termina el metodo y devuelve _dotnet_dialogue_manager a quien lo llamo.
	return _dotnet_dialogue_manager


# Define el metodo _bridge_get_new_instance para agrupar esta accion del script.
func _bridge_get_new_instance() -> Node:
	# For some reason duplicating the node with its signals doesn't work so we have to copy them over manually
	var instance = new()
	# Ejecuta esta instruccion: for s: Dictionary in dialogue_started.get_connections():.
	for s: Dictionary in dialogue_started.get_connections():
		# Llama al metodo instance.dialogue_started.connect para realizar esta accion en este punto.
		instance.dialogue_started.connect(s.callable)
	# Ejecuta esta instruccion: for s: Dictionary in passed_title.get_connections():.
	for s: Dictionary in passed_title.get_connections():
		# Llama al metodo instance.passed_title.connect para realizar esta accion en este punto.
		instance.passed_title.connect(s.callable)
	# Ejecuta esta instruccion: for s: Dictionary in got_dialogue.get_connections():.
	for s: Dictionary in got_dialogue.get_connections():
		# Llama al metodo instance.got_dialogue.connect para realizar esta accion en este punto.
		instance.got_dialogue.connect(s.callable)
	# Ejecuta esta instruccion: for s: Dictionary in mutated.get_connections():.
	for s: Dictionary in mutated.get_connections():
		# Llama al metodo instance.mutated.connect para realizar esta accion en este punto.
		instance.mutated.connect(s.callable)
	# Ejecuta esta instruccion: for s: Dictionary in dialogue_ended.get_connections():.
	for s: Dictionary in dialogue_ended.get_connections():
		# Llama al metodo instance.dialogue_ended.connect para realizar esta accion en este punto.
		instance.dialogue_ended.connect(s.callable)
	# Guarda en instance.get_current_scene el resultado de get_current_scene.
	instance.get_current_scene = get_current_scene
	# Termina el metodo y devuelve instance a quien lo llamo.
	return instance


# Define el metodo _bridge_get_next_dialogue_line para agrupar esta accion del script.
func _bridge_get_next_dialogue_line(resource: DialogueResource, key: String, extra_game_states: Array = []) -> void:
	# dotnet needs at least one await tick of the signal gets called too quickly
	await Engine.get_main_loop().process_frame

	# Crea line e inicializa su valor con await get_next_dialogue_line(resource, key, extra_game_states).
	var line = await get_next_dialogue_line(resource, key, extra_game_states)
	# Emite la senal bridge_get_next_dialogue_line_completed con estos datos: line.
	bridge_get_next_dialogue_line_completed.emit(line)


# Define el metodo _bridge_mutate para agrupar esta accion del script.
func _bridge_mutate(mutation: Dictionary, extra_game_states: Array, is_inline_mutation: bool = false) -> void:
	# Espera a que termine _mutate(mutation, extra_game_states, is_inline_mutation) antes de continuar.
	await _mutate(mutation, extra_game_states, is_inline_mutation)
	# Emite la senal bridge_mutated con estos datos: ninguno.
	bridge_mutated.emit()


#endregion

#region Internal helpers


# Show a message or crash with error
func show_error_for_missing_state_value(message: String, will_show: bool = true) -> void:
	# Ejecuta esta instruccion: if not will_show: return.
	if not will_show: return

	# Comprueba DMSettings.get_setting(DMSettings.IGNORE_MISSING_STATE_VALUES, false); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if DMSettings.get_setting(DMSettings.IGNORE_MISSING_STATE_VALUES, false):
		# Llama al metodo push_error para realizar esta accion en este punto.
		push_error(message)
	# Comprueba will_show si las condiciones anteriores resultaron falsas.
	elif will_show:
		# If you're here then you're missing a method or property in your game state. The error
		# message down in the debugger will give you some more information.
		assert(false, message)


# Translate a string
func translate(data: Dictionary) -> String:
	# Comprueba TranslationServer.get_loaded_locales().size() == 0 or translation_source == DMConstants.TranslationSource.None; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if TranslationServer.get_loaded_locales().size() == 0 or translation_source == DMConstants.TranslationSource.None:
		# Termina el metodo y devuelve data.text a quien lo llamo.
		return data.text

	# Crea translation_key e inicializa su valor con data.get(&"translation_key", data.text).
	var translation_key: String = data.get(&"translation_key", data.text)

	# Comprueba translation_key == "" or translation_key == data.text; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if translation_key == "" or translation_key == data.text:
		# Termina el metodo y devuelve tr(data.text) a quien lo llamo.
		return tr(data.text)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Line IDs work slightly differently depending on whether the translation came from a
		# CSV or a PO file. CSVs use the line ID (or the line itself) as the translatable string
		# whereas POs use the ID as context and the line itself as the translatable string.
		match translation_source:
			# Ejecuta esta instruccion: DMConstants.TranslationSource.PO:.
			DMConstants.TranslationSource.PO:
				# Termina el metodo y devuelve tr(data.text, StringName(translation_key)) a quien lo llamo.
				return tr(data.text, StringName(translation_key))

			# Ejecuta esta instruccion: DMConstants.TranslationSource.CSV:.
			DMConstants.TranslationSource.CSV:
				# Termina el metodo y devuelve tr(translation_key) a quien lo llamo.
				return tr(translation_key)

			# Ejecuta esta instruccion: DMConstants.TranslationSource.Guess:.
			DMConstants.TranslationSource.Guess:
				# Crea translation_files e inicializa su valor con ProjectSettings.get_setting(&"internationalization/locale/translations").
				var translation_files: Array = ProjectSettings.get_setting(&"internationalization/locale/translations")
				# Comprueba translation_files.filter(func(f: String): return f.get_extension() in [&"po", &"mo"]).size() > 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if translation_files.filter(func(f: String): return f.get_extension() in [&"po", &"mo"]).size() > 0:
					# Assume PO
					return tr(data.text, StringName(translation_key))
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Assume CSV
					return tr(translation_key)

	# Termina el metodo y devuelve tr(translation_key) a quien lo llamo.
	return tr(translation_key)


# Create a line of dialogue
func create_dialogue_line(data: Dictionary, extra_game_states: Array) -> DialogueLine:
	# Compara data.type con los casos siguientes y ejecuta el que coincida.
	match data.type:
		# Ejecuta esta instruccion: DMConstants.TYPE_DIALOGUE:.
		DMConstants.TYPE_DIALOGUE:
			# Crea resolved_data e inicializa su valor con await get_resolved_line_data(data, extra_game_states).
			var resolved_data: DMResolvedLineData = await get_resolved_line_data(data, extra_game_states)
			# Termina el metodo y devuelve DialogueLine.new({ a quien lo llamo.
			return DialogueLine.new({
				# Guarda en id el resultado de data.get(&"id", ""),.
				id = data.get(&"id", ""),
				# Guarda en type el resultado de DMConstants.TYPE_DIALOGUE,.
				type = DMConstants.TYPE_DIALOGUE,
				# Guarda en next_id el resultado de data.next_id,.
				next_id = data.next_id,
				# Guarda en character el resultado de await get_resolved_character(data, extra_game_states),.
				character = await get_resolved_character(data, extra_game_states),
				# Guarda en character_replacements el resultado de data.get(&"character_replacements", [] as Array[Dictionary]),.
				character_replacements = data.get(&"character_replacements", [] as Array[Dictionary]),
				# Guarda en text el resultado de resolved_data.text,.
				text = resolved_data.text,
				# Guarda en text_replacements el resultado de data.get(&"text_replacements", [] as Array[Dictionary]),.
				text_replacements = data.get(&"text_replacements", [] as Array[Dictionary]),
				# Guarda en translation_key el resultado de data.get(&"translation_key", data.text),.
				translation_key = data.get(&"translation_key", data.text),
				# Guarda en pauses el resultado de resolved_data.pauses,.
				pauses = resolved_data.pauses,
				# Guarda en speeds el resultado de resolved_data.speeds,.
				speeds = resolved_data.speeds,
				# Guarda en inline_mutations el resultado de resolved_data.mutations,.
				inline_mutations = resolved_data.mutations,
				# Guarda en time el resultado de resolved_data.time,.
				time = resolved_data.time,
				# Guarda en tags el resultado de data.get(&"tags", []),.
				tags = data.get(&"tags", []),
				# Guarda en extra_game_states el resultado de extra_game_states.
				extra_game_states = extra_game_states
			# Ejecuta esta instruccion: }).
			})

		# Ejecuta esta instruccion: DMConstants.TYPE_RESPONSE:.
		DMConstants.TYPE_RESPONSE:
			# Termina el metodo y devuelve DialogueLine.new({ a quien lo llamo.
			return DialogueLine.new({
				# Guarda en id el resultado de data.get(&"id", ""),.
				id = data.get(&"id", ""),
				# Guarda en type el resultado de DMConstants.TYPE_RESPONSE,.
				type = DMConstants.TYPE_RESPONSE,
				# Guarda en next_id el resultado de data.next_id,.
				next_id = data.next_id,
				# Guarda en tags el resultado de data.get(&"tags", []),.
				tags = data.get(&"tags", []),
				# Guarda en extra_game_states el resultado de extra_game_states.
				extra_game_states = extra_game_states
			# Ejecuta esta instruccion: }).
			})

		# Ejecuta esta instruccion: DMConstants.TYPE_MUTATION:.
		DMConstants.TYPE_MUTATION:
			# Termina el metodo y devuelve DialogueLine.new({ a quien lo llamo.
			return DialogueLine.new({
				# Guarda en id el resultado de data.get(&"id", ""),.
				id = data.get(&"id", ""),
				# Guarda en type el resultado de DMConstants.TYPE_MUTATION,.
				type = DMConstants.TYPE_MUTATION,
				# Guarda en next_id el resultado de data.next_id,.
				next_id = data.next_id,
				# Guarda en mutation el resultado de data.mutation,.
				mutation = data.mutation,
				# Guarda en extra_game_states el resultado de extra_game_states.
				extra_game_states = extra_game_states
			# Ejecuta esta instruccion: }).
			})

	# Termina el metodo y devuelve null a quien lo llamo.
	return null


# Create a response
func create_response(data: Dictionary, extra_game_states: Array) -> DialogueResponse:
	# Crea resolved_data e inicializa su valor con await get_resolved_line_data(data, extra_game_states).
	var resolved_data: DMResolvedLineData = await get_resolved_line_data(data, extra_game_states)
	# Termina el metodo y devuelve DialogueResponse.new({ a quien lo llamo.
	return DialogueResponse.new({
		# Guarda en id el resultado de data.get(&"id", ""),.
		id = data.get(&"id", ""),
		# Guarda en type el resultado de DMConstants.TYPE_RESPONSE,.
		type = DMConstants.TYPE_RESPONSE,
		# Guarda en next_id el resultado de data.next_id,.
		next_id = data.next_id,
		# Guarda en is_allowed el resultado de data.is_allowed,.
		is_allowed = data.is_allowed,
		# Guarda en condition_as_text el resultado de data.get(&"condition_as_text", ""),.
		condition_as_text = data.get(&"condition_as_text", ""),
		# Guarda en character el resultado de await get_resolved_character(data, extra_game_states),.
		character = await get_resolved_character(data, extra_game_states),
		# Guarda en character_replacements el resultado de data.get(&"character_replacements", [] as Array[Dictionary]),.
		character_replacements = data.get(&"character_replacements", [] as Array[Dictionary]),
		# Guarda en text el resultado de resolved_data.text,.
		text = resolved_data.text,
		# Guarda en text_replacements el resultado de data.get(&"text_replacements", [] as Array[Dictionary]),.
		text_replacements = data.get(&"text_replacements", [] as Array[Dictionary]),
		# Guarda en tags el resultado de data.get(&"tags", []),.
		tags = data.get(&"tags", []),
		# Guarda en translation_key el resultado de data.get(&"translation_key", data.text),.
		translation_key = data.get(&"translation_key", data.text),
	# Ejecuta esta instruccion: }).
	})


# Get the current game states
func _get_game_states(extra_game_states: Array) -> Array:
	# Comprueba not _has_loaded_autoloads; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not _has_loaded_autoloads:
		# Guarda en _has_loaded_autoloads el resultado de true.
		_has_loaded_autoloads = true
		# Add any autoloads to a generic state so we can refer to them by name
		for child in Engine.get_main_loop().root.get_children():
			# Ignore the dialogue manager
			if child.name == &"DialogueManager": continue
			# Ignore the current main scene
			if Engine.get_main_loop().current_scene and child.name == Engine.get_main_loop().current_scene.name: continue
			# Add the node to our known autoloads
			_autoloads[child.name] = child
		# Guarda en game_states el resultado de [_autoloads].
		game_states = [_autoloads]
		# Add any other state shortcuts from settings
		for node_name in DMSettings.get_setting(DMSettings.STATE_AUTOLOAD_SHORTCUTS, ""):
			# Crea state e inicializa su valor con Engine.get_main_loop().root.get_node_or_null(NodePath(node_name)).
			var state: Node = Engine.get_main_loop().root.get_node_or_null(NodePath(node_name))
			# Comprueba state; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if state:
				# Llama al metodo game_states.append para realizar esta accion en este punto.
				game_states.append(state)

	# Crea current_scene e inicializa su valor con get_current_scene.call().
	var current_scene: Node = get_current_scene.call()
	# Crea unique_states e inicializa su valor con [].
	var unique_states: Array = []
	# Recorre extra_game_states + [current_scene] + game_states y asigna cada elemento a state en cada vuelta.
	for state in extra_game_states + [current_scene] + game_states:
		# Comprueba state != null and not unique_states.has(state); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if state != null and not unique_states.has(state):
			# Llama al metodo unique_states.append para realizar esta accion en este punto.
			unique_states.append(state)
	# Termina el metodo y devuelve unique_states a quien lo llamo.
	return unique_states


# Check if a condition is met
func _check_condition(data: Dictionary, extra_game_states: Array) -> bool:
	# Termina el metodo y devuelve bool(await _resolve_condition_value(data, extra_game_states)) a quien lo llamo.
	return bool(await _resolve_condition_value(data, extra_game_states))


# Resolve a condition's expression value
func _resolve_condition_value(data: Dictionary, extra_game_states: Array) -> Variant:
	# Ejecuta esta instruccion: if data.get(&"condition", null) == null: return true.
	if data.get(&"condition", null) == null: return true
	# Ejecuta esta instruccion: if data.condition.is_empty(): return true.
	if data.condition.is_empty(): return true

	# Termina el metodo y devuelve await _resolve(data.condition.expression.duplicate(true), extra_game_states) a quien lo llamo.
	return await _resolve(data.condition.expression.duplicate(true), extra_game_states)


# Check if a match value matches a case value
func _check_case_value(match_value: Variant, data: Dictionary, extra_game_states: Array) -> bool:
	# Ejecuta esta instruccion: if data.get(&"condition", null) == null: return true.
	if data.get(&"condition", null) == null: return true
	# Ejecuta esta instruccion: if data.condition.is_empty(): return true.
	if data.condition.is_empty(): return true

	# Crea expression e inicializa su valor con data.condition.expression.duplicate(true).
	var expression: Array[Dictionary] = data.condition.expression.duplicate(true)

	# Check for multiple values
	var expressions_to_check: Array = []
	# Crea previous_comma_index e inicializa su valor con 0.
	var previous_comma_index: int = 0
	# Recorre range(0, expression.size()) y asigna cada elemento a i en cada vuelta.
	for i in range(0, expression.size()):
		# Comprueba expression[i].type == DMConstants.TOKEN_COMMA; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if expression[i].type == DMConstants.TOKEN_COMMA:
			# Llama al metodo expressions_to_check.append para realizar esta accion en este punto.
			expressions_to_check.append(expression.slice(previous_comma_index, i))
			# Guarda en previous_comma_index el resultado de i + 1.
			previous_comma_index = i + 1
		# Comprueba i == expression.size() - 1 si las condiciones anteriores resultaron falsas.
		elif i == expression.size() - 1:
			# Llama al metodo expressions_to_check.append para realizar esta accion en este punto.
			expressions_to_check.append(expression.slice(previous_comma_index))

	# Recorre expressions_to_check y asigna cada elemento a expression_to_check en cada vuelta.
	for expression_to_check in expressions_to_check:
		# If the when is a comparison when insert the match value as the first value to compare to
		var already_compared: bool = false
		# Comprueba expression_to_check[0].type == DMConstants.TOKEN_COMPARISON; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if expression_to_check[0].type == DMConstants.TOKEN_COMPARISON:
			# Llama al metodo expression_to_check.insert para realizar esta accion en este punto.
			expression_to_check.insert(0, {
				# Guarda en type el resultado de DMConstants.TOKEN_VALUE,.
				type = DMConstants.TOKEN_VALUE,
				# Guarda en value el resultado de match_value.
				value = match_value
			# Ejecuta esta instruccion: }).
			})
			# Guarda en already_compared el resultado de true.
			already_compared = true

		# Crea resolved_value e inicializa su valor con await _resolve(expression_to_check, extra_game_states).
		var resolved_value = await _resolve(expression_to_check, extra_game_states)
		# Comprueba (already_compared and resolved_value) or match_value == resolved_value; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if (already_compared and resolved_value) or match_value == resolved_value:
			# Termina el metodo y devuelve true a quien lo llamo.
			return true

	# Termina el metodo y devuelve false a quien lo llamo.
	return false


# Make a change to game state or run a method
func _mutate(mutation: Dictionary, extra_game_states: Array, is_inline_mutation: bool = false) -> void:
	# Crea expression e inicializa su valor con mutation.expression.
	var expression: Array[Dictionary] = mutation.expression

	# Handle built in mutations
	if expression[0].type == DMConstants.TOKEN_FUNCTION and expression[0].function in [&"wait", &"Wait", &"debug", &"Debug"]:
		# Crea args e inicializa su valor con await _resolve_each(expression[0].value, extra_game_states).
		var args: Array = await _resolve_each(expression[0].value, extra_game_states)
		# Compara expression[0].function con los casos siguientes y ejecuta el que coincida.
		match expression[0].function:
			# Ejecuta esta instruccion: &"wait", &"Wait":.
			&"wait", &"Wait":
				# Emite la senal mutated con estos datos: mutation.merged({ is_inline = is_inline_mutation }).
				mutated.emit(mutation.merged({ is_inline = is_inline_mutation }))
				# Espera a que termine Engine.get_main_loop().create_timer(float(args[0])).timeout antes de continuar.
				await Engine.get_main_loop().create_timer(float(args[0])).timeout
				# Termina el metodo sin devolver un valor.
				return

			# Ejecuta esta instruccion: &"debug", &"Debug":.
			&"debug", &"Debug":
				# Llama al metodo prints para realizar esta accion en este punto.
				prints("Debug:", args)
				# Espera a que termine Engine.get_main_loop().process_frame antes de continuar.
				await Engine.get_main_loop().process_frame

	# Or pass through to the resolver
	else:
		# Comprueba not _mutation_contains_assignment(mutation.expression) and not is_inline_mutation; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if not _mutation_contains_assignment(mutation.expression) and not is_inline_mutation:
			# Emite la senal mutated con estos datos: mutation.merged({ is_inline = is_inline_mutation }).
			mutated.emit(mutation.merged({ is_inline = is_inline_mutation }))

		# Comprueba mutation.get("is_blocking", true); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if mutation.get("is_blocking", true):
			# Espera a que termine _resolve(mutation.expression.duplicate(true), extra_game_states) antes de continuar.
			await _resolve(mutation.expression.duplicate(true), extra_game_states)
			# Termina el metodo sin devolver un valor.
			return
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Llama al metodo _resolve para realizar esta accion en este punto.
			_resolve(mutation.expression.duplicate(true), extra_game_states)

	# Wait one frame to give the dialogue handler a chance to yield
	await Engine.get_main_loop().process_frame


# Check if a mutation contains an assignment token.
func _mutation_contains_assignment(mutation: Array) -> bool:
	# Recorre mutation y asigna cada elemento a token en cada vuelta.
	for token in mutation:
		# Comprueba token.type == DMConstants.TOKEN_ASSIGNMENT; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if token.type == DMConstants.TOKEN_ASSIGNMENT:
			# Termina el metodo y devuelve true a quien lo llamo.
			return true
	# Termina el metodo y devuelve false a quien lo llamo.
	return false


# Replace an array of line IDs with their response prompts
func _get_responses(ids: Array, resource: DialogueResource, id_trail: String, extra_game_states: Array) -> Array[DialogueResponse]:
	# Crea responses e inicializa su valor con [].
	var responses: Array[DialogueResponse] = []
	# Recorre ids y asigna cada elemento a id en cada vuelta.
	for id in ids:
		# Crea data e inicializa su valor con resource.lines.get(id).duplicate(true).
		var data: Dictionary = resource.lines.get(id).duplicate(true)
		# Guarda en data.is_allowed el resultado de await _check_condition(data, extra_game_states).
		data.is_allowed = await _check_condition(data, extra_game_states)
		# Crea response e inicializa su valor con await create_response(data, extra_game_states).
		var response: DialogueResponse = await create_response(data, extra_game_states)
		# Suma a response.next_id el valor id_trail respecto de su valor anterior.
		response.next_id += id_trail
		# Llama al metodo responses.append para realizar esta accion en este punto.
		responses.append(response)

	# Termina el metodo y devuelve responses a quien lo llamo.
	return responses


# Get a value on the current scene or game state
func _get_state_value(property: String, extra_game_states: Array):
	# Special case for static primitive calls
	if property == "Color":
		# Termina el metodo y devuelve Color() a quien lo llamo.
		return Color()
	# Comprueba property == "Vector2" si las condiciones anteriores resultaron falsas.
	elif property == "Vector2":
		# Termina el metodo y devuelve Vector2.ZERO a quien lo llamo.
		return Vector2.ZERO
	# Comprueba property == "Vector3" si las condiciones anteriores resultaron falsas.
	elif property == "Vector3":
		# Termina el metodo y devuelve Vector3.ZERO a quien lo llamo.
		return Vector3.ZERO
	# Comprueba property == "Vector4" si las condiciones anteriores resultaron falsas.
	elif property == "Vector4":
		# Termina el metodo y devuelve Vector4.ZERO a quien lo llamo.
		return Vector4.ZERO
	# Comprueba property == "Quaternion" si las condiciones anteriores resultaron falsas.
	elif property == "Quaternion":
		# Termina el metodo y devuelve Quaternion() a quien lo llamo.
		return Quaternion()

	# Crea expression e inicializa su valor con Expression.new().
	var expression = Expression.new()
	# Comprueba expression.parse(property) != OK; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if expression.parse(property) != OK:
		# Llama al metodo assert para realizar esta accion en este punto.
		assert(false, DMConstants.translate(&"runtime.invalid_expression").format({ expression = property, error = expression.get_error_text() }))

	# Warn about possible name collisions
	_warn_about_state_name_collisions(property, extra_game_states)

	# Recorre _get_game_states(extra_game_states) y asigna cada elemento a state en cada vuelta.
	for state in _get_game_states(extra_game_states):
		# Comprueba typeof(state) == TYPE_DICTIONARY; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if typeof(state) == TYPE_DICTIONARY:
			# Comprueba state.has(property); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if state.has(property):
				# Termina el metodo y devuelve state.get(property) a quien lo llamo.
				return state.get(property)
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Crea result e inicializa su valor con expression.execute([], state, false).
			var result = expression.execute([], state, false)
			# Comprueba not expression.has_execute_failed(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not expression.has_execute_failed():
				# Termina el metodo y devuelve result a quien lo llamo.
				return result

	# Comprueba include_singletons and Engine.has_singleton(property); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if include_singletons and Engine.has_singleton(property):
		# Termina el metodo y devuelve Engine.get_singleton(property) a quien lo llamo.
		return Engine.get_singleton(property)

	# Comprueba include_classes; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if include_classes:
		# Recorre ProjectSettings.get_global_class_list() y asigna cada elemento a class_data en cada vuelta.
		for class_data in ProjectSettings.get_global_class_list():
			# Comprueba class_data.get(&"class") == property; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if class_data.get(&"class") == property:
				# Termina el metodo y devuelve load(class_data.path).new() a quien lo llamo.
				return load(class_data.path).new()

	# Llama al metodo show_error_for_missing_state_value para realizar esta accion en este punto.
	show_error_for_missing_state_value(DMConstants.translate(&"runtime.property_not_found").format({ property = property, states = _get_state_shortcut_names(extra_game_states) }))


# Print warnings for top-level state name collisions.
func _warn_about_state_name_collisions(target_key: String, extra_game_states: Array) -> void:
	# Don't run the check if this is a release build
	if not OS.is_debug_build(): return
	# Also don't run if the setting is off
	if not DMSettings.get_setting(DMSettings.WARN_ABOUT_METHOD_PROPERTY_OR_SIGNAL_NAME_CONFLICTS, false): return

	# Get the list of state shortcuts.
	var state_shortcuts: Array = []
	# Recorre DMSettings.get_setting(DMSettings.STATE_AUTOLOAD_SHORTCUTS, "") y asigna cada elemento a node_name en cada vuelta.
	for node_name in DMSettings.get_setting(DMSettings.STATE_AUTOLOAD_SHORTCUTS, ""):
		# Crea state e inicializa su valor con Engine.get_main_loop().root.get_node_or_null(NodePath(node_name)).
		var state: Node = Engine.get_main_loop().root.get_node_or_null(NodePath(node_name))
		# Comprueba state; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if state:
			# Llama al metodo state_shortcuts.append para realizar esta accion en este punto.
			state_shortcuts.append(state)

	# Check any top level names for a collision
	var states_with_key: Array = []
	# Recorre extra_game_states + [get_current_scene.call()] + state_shortcuts y asigna cada elemento a state en cada vuelta.
	for state in extra_game_states + [get_current_scene.call()] + state_shortcuts:
		# Comprueba state is Dictionary; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if state is Dictionary:
			# Comprueba state.keys().has(target_key); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if state.keys().has(target_key):
				# Llama al metodo states_with_key.append para realizar esta accion en este punto.
				states_with_key.append("Dictionary")
		# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
		else:
			# Crea script e inicializa su valor con (state as Object).get_script().
			var script: Script = (state as Object).get_script()
			# Comprueba script == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if script == null:
				# Pasa directamente a la siguiente vuelta del bucle.
				continue

			# Recorre script.get_script_method_list() y asigna cada elemento a method en cada vuelta.
			for method in script.get_script_method_list():
				# Comprueba method.name == target_key and not states_with_key.has(state.name); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if method.name == target_key and not states_with_key.has(state.name):
					# Llama al metodo states_with_key.append para realizar esta accion en este punto.
					states_with_key.append(state.name)
					# Termina inmediatamente el bucle actual.
					break

			# Recorre script.get_script_property_list() y asigna cada elemento a property en cada vuelta.
			for property in script.get_script_property_list():
				# Comprueba property.name == target_key and not states_with_key.has(state.name); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if property.name == target_key and not states_with_key.has(state.name):
					# Llama al metodo states_with_key.append para realizar esta accion en este punto.
					states_with_key.append(state.name)
					# Termina inmediatamente el bucle actual.
					break

			# Recorre script.get_script_signal_list() y asigna cada elemento a signal_info en cada vuelta.
			for signal_info in script.get_script_signal_list():
				# Comprueba signal_info.name == target_key and not states_with_key.has(state.name); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if signal_info.name == target_key and not states_with_key.has(state.name):
					# Llama al metodo states_with_key.append para realizar esta accion en este punto.
					states_with_key.append(state.name)
					# Termina inmediatamente el bucle actual.
					break

	# Comprueba states_with_key.size() > 1; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if states_with_key.size() > 1:
		# Llama al metodo push_warning para realizar esta accion en este punto.
		push_warning(DMConstants.translate(&"runtime.top_level_states_share_name").format({ states = ", ".join(states_with_key), key = target_key }))


# Set a value on the current scene or game state
func _set_state_value(property: String, value, extra_game_states: Array) -> void:
	# Recorre _get_game_states(extra_game_states) y asigna cada elemento a state en cada vuelta.
	for state in _get_game_states(extra_game_states):
		# Comprueba typeof(state) == TYPE_DICTIONARY; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if typeof(state) == TYPE_DICTIONARY:
			# Comprueba state.has(property); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if state.has(property):
				# Ejecuta esta instruccion: state[property] = value.
				state[property] = value
				# Termina el metodo sin devolver un valor.
				return
		# Comprueba _thing_has_property(state, property) si las condiciones anteriores resultaron falsas.
		elif _thing_has_property(state, property):
			# Llama al metodo state.set para realizar esta accion en este punto.
			state.set(property, value)
			# Termina el metodo sin devolver un valor.
			return

	# Comprueba property.to_snake_case() != property; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if property.to_snake_case() != property:
		# Llama al metodo show_error_for_missing_state_value para realizar esta accion en este punto.
		show_error_for_missing_state_value(DMConstants.translate(&"runtime.property_not_found_missing_export").format({ property = property, states = _get_state_shortcut_names(extra_game_states) }))
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Llama al metodo show_error_for_missing_state_value para realizar esta accion en este punto.
		show_error_for_missing_state_value(DMConstants.translate(&"runtime.property_not_found").format({ property = property, states = _get_state_shortcut_names(extra_game_states) }))


# Get the list of state shortcut names
func _get_state_shortcut_names(extra_game_states: Array) -> String:
	# Crea states e inicializa su valor con _get_game_states(extra_game_states).
	var states = _get_game_states(extra_game_states)
	# Llama al metodo states.erase para realizar esta accion en este punto.
	states.erase(_autoloads)
	# Termina el metodo y devuelve ", ".join(states.map(func(s): return "\"%s\"" % (s.name if "name" in s else s))) a quien lo llamo.
	return ", ".join(states.map(func(s): return "\"%s\"" % (s.name if "name" in s else s)))


# Resolve an array of expressions.
func _resolve_each(array: Array, extra_game_states: Array) -> Array:
	# Crea results e inicializa su valor con [].
	var results: Array = []
	# Recorre array y asigna cada elemento a item en cada vuelta.
	for item in array:
		# Comprueba not item[0].type in [DMConstants.TOKEN_BRACE_CLOSE, DMConstants.TOKEN_BRACKET_CLOSE, DMConstants.TOKEN_PARENS_CLOSE]; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if not item[0].type in [DMConstants.TOKEN_BRACE_CLOSE, DMConstants.TOKEN_BRACKET_CLOSE, DMConstants.TOKEN_PARENS_CLOSE]:
			# Llama al metodo results.append para realizar esta accion en este punto.
			results.append(await _resolve(item.duplicate(true), extra_game_states))
	# Termina el metodo y devuelve results a quien lo llamo.
	return results


# Collapse any expressions
func _resolve(tokens: Array, extra_game_states: Array):
	# Crea i e inicializa su valor con 0.
	var i: int = 0
	# Crea limit e inicializa su valor con 0.
	var limit: int = 0

	# Handle groups first
	for token in tokens:
		# Comprueba token.type == DMConstants.TOKEN_GROUP; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if token.type == DMConstants.TOKEN_GROUP:
			# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
			token.type = DMConstants.TOKEN_VALUE
			# Guarda en token.value el resultado de await _resolve(token.value, extra_game_states).
			token.value = await _resolve(token.value, extra_game_states)

	# Then variables/methods
	i = 0
	# Guarda en limit el resultado de 0.
	limit = 0
	# Repite este bloque mientras i < tokens.size() and limit < 1000 sea verdadero.
	while i < tokens.size() and limit < 1000:
		# Suma a limit el valor 1 respecto de su valor anterior.
		limit += 1
		# Crea token e inicializa su valor con tokens[i].
		var token: Dictionary = tokens[i]

		# Comprueba token.type == DMConstants.TOKEN_NULL_COALESCE; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if token.type == DMConstants.TOKEN_NULL_COALESCE:
			# Crea caller e inicializa su valor con tokens[i - 1].
			var caller: Dictionary = tokens[i - 1]
			# Comprueba caller.value == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if caller.value == null:
				# If the caller is null then the method/property is also null
				caller.type = DMConstants.TOKEN_VALUE
				# Guarda en caller.value el resultado de null.
				caller.value = null
				# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
				tokens.remove_at(i + 1)
				# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
				tokens.remove_at(i)
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Guarda en token.type el resultado de DMConstants.TOKEN_DOT.
				token.type = DMConstants.TOKEN_DOT

		# Comprueba token.type == DMConstants.TOKEN_FUNCTION si las condiciones anteriores resultaron falsas.
		elif token.type == DMConstants.TOKEN_FUNCTION:
			# Crea function_name e inicializa su valor con token.function.
			var function_name: String = token.function
			# Crea args e inicializa su valor con await _resolve_each(token.value, extra_game_states).
			var args = await _resolve_each(token.value, extra_game_states)
			# Comprueba tokens[i - 1].type == DMConstants.TOKEN_DOT; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if tokens[i - 1].type == DMConstants.TOKEN_DOT:
				# If we are calling a deeper function then we need to collapse the
				# value into the thing we are calling the function on
				var caller: Dictionary = tokens[i - 2]
				# Comprueba Builtins.is_supported(caller.value); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if Builtins.is_supported(caller.value):
					# Guarda en caller.type el resultado de DMConstants.TOKEN_VALUE.
					caller.type = DMConstants.TOKEN_VALUE
					# Guarda en caller.value el resultado de Builtins.resolve_method(caller.value, function_name, args).
					caller.value = Builtins.resolve_method(caller.value, function_name, args)
					# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
					tokens.remove_at(i)
					# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
					tokens.remove_at(i - 1)
					# Resta de i el valor 2 respecto de su valor anterior.
					i -= 2
				# Comprueba _thing_has_method(caller.value, function_name, args) si las condiciones anteriores resultaron falsas.
				elif _thing_has_method(caller.value, function_name, args):
					# Guarda en caller.type el resultado de DMConstants.TOKEN_VALUE.
					caller.type = DMConstants.TOKEN_VALUE
					# Guarda en caller.value el resultado de await _resolve_thing_method(caller.value, function_name, args).
					caller.value = await _resolve_thing_method(caller.value, function_name, args)
					# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
					tokens.remove_at(i)
					# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
					tokens.remove_at(i - 1)
					# Resta de i el valor 2 respecto de su valor anterior.
					i -= 2
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Llama al metodo show_error_for_missing_state_value para realizar esta accion en este punto.
					show_error_for_missing_state_value(DMConstants.translate(&"runtime.method_not_callable").format({ method = function_name, object = str(caller.value) }))
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Crea found e inicializa su valor con false.
				var found: bool = false
				# Compara function_name con los casos siguientes y ejecuta el que coincida.
				match function_name:
					# Ejecuta esta instruccion: &"str":.
					&"str":
						# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
						token.type = DMConstants.TOKEN_VALUE
						# Guarda en token.value el resultado de str(args[0]).
						token.value = str(args[0])
						# Guarda en found el resultado de true.
						found = true
					# Ejecuta esta instruccion: &"Vector2":.
					&"Vector2":
						# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
						token.type = DMConstants.TOKEN_VALUE
						# Guarda en token.value el resultado de Vector2(args[0], args[1]).
						token.value = Vector2(args[0], args[1])
						# Guarda en found el resultado de true.
						found = true
					# Ejecuta esta instruccion: &"Vector2i":.
					&"Vector2i":
						# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
						token.type = DMConstants.TOKEN_VALUE
						# Guarda en token.value el resultado de Vector2i(args[0], args[1]).
						token.value = Vector2i(args[0], args[1])
						# Guarda en found el resultado de true.
						found = true
					# Ejecuta esta instruccion: &"Vector3":.
					&"Vector3":
						# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
						token.type = DMConstants.TOKEN_VALUE
						# Guarda en token.value el resultado de Vector3(args[0], args[1], args[2]).
						token.value = Vector3(args[0], args[1], args[2])
						# Guarda en found el resultado de true.
						found = true
					# Ejecuta esta instruccion: &"Vector3i":.
					&"Vector3i":
						# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
						token.type = DMConstants.TOKEN_VALUE
						# Guarda en token.value el resultado de Vector3i(args[0], args[1], args[2]).
						token.value = Vector3i(args[0], args[1], args[2])
						# Guarda en found el resultado de true.
						found = true
					# Ejecuta esta instruccion: &"Vector4":.
					&"Vector4":
						# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
						token.type = DMConstants.TOKEN_VALUE
						# Guarda en token.value el resultado de Vector4(args[0], args[1], args[2], args[3]).
						token.value = Vector4(args[0], args[1], args[2], args[3])
						# Guarda en found el resultado de true.
						found = true
					# Ejecuta esta instruccion: &"Vector4i":.
					&"Vector4i":
						# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
						token.type = DMConstants.TOKEN_VALUE
						# Guarda en token.value el resultado de Vector4i(args[0], args[1], args[2], args[3]).
						token.value = Vector4i(args[0], args[1], args[2], args[3])
						# Guarda en found el resultado de true.
						found = true
					# Ejecuta esta instruccion: &"Quaternion":.
					&"Quaternion":
						# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
						token.type = DMConstants.TOKEN_VALUE
						# Guarda en token.value el resultado de Quaternion(args[0], args[1], args[2], args[3]).
						token.value = Quaternion(args[0], args[1], args[2], args[3])
						# Guarda en found el resultado de true.
						found = true
					# Ejecuta esta instruccion: &"Callable":.
					&"Callable":
						# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
						token.type = DMConstants.TOKEN_VALUE
						# Compara args.size() con los casos siguientes y ejecuta el que coincida.
						match args.size():
							# Asocia la clave 0 con  dentro del diccionario.
							0:
								# Guarda en token.value el resultado de Callable().
								token.value = Callable()
							# Asocia la clave 1 con  dentro del diccionario.
							1:
								# Guarda en token.value el resultado de Callable(args[0]).
								token.value = Callable(args[0])
							# Asocia la clave 2 con  dentro del diccionario.
							2:
								# Guarda en token.value el resultado de Callable(args[0], args[1]).
								token.value = Callable(args[0], args[1])
						# Guarda en found el resultado de true.
						found = true
					# Ejecuta esta instruccion: &"Color":.
					&"Color":
						# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
						token.type = DMConstants.TOKEN_VALUE
						# Compara args.size() con los casos siguientes y ejecuta el que coincida.
						match args.size():
							# Asocia la clave 0 con  dentro del diccionario.
							0:
								# Guarda en token.value el resultado de Color().
								token.value = Color()
							# Asocia la clave 1 con  dentro del diccionario.
							1:
								# Guarda en token.value el resultado de Color(args[0]).
								token.value = Color(args[0])
							# Asocia la clave 2 con  dentro del diccionario.
							2:
								# Guarda en token.value el resultado de Color(args[0], args[1]).
								token.value = Color(args[0], args[1])
							# Asocia la clave 3 con  dentro del diccionario.
							3:
								# Guarda en token.value el resultado de Color(args[0], args[1], args[2]).
								token.value = Color(args[0], args[1], args[2])
							# Asocia la clave 4 con  dentro del diccionario.
							4:
								# Guarda en token.value el resultado de Color(args[0], args[1], args[2], args[3]).
								token.value = Color(args[0], args[1], args[2], args[3])
						# Guarda en found el resultado de true.
						found = true
					# Ejecuta esta instruccion: &"load", &"Load":.
					&"load", &"Load":
						# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
						token.type = DMConstants.TOKEN_VALUE
						# Guarda en token.value el resultado de load(args[0]).
						token.value = load(args[0])
						# Guarda en found el resultado de true.
						found = true
					# Ejecuta esta instruccion: &"roll_dice", &"RollDice":.
					&"roll_dice", &"RollDice":
						# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
						token.type = DMConstants.TOKEN_VALUE
						# Guarda en token.value el resultado de randi_range(1, args[0]).
						token.value = randi_range(1, args[0])
						# Guarda en found el resultado de true.
						found = true
					# Asocia la clave _ con  dentro del diccionario.
					_:
						# Check for top level name conflicts
						_warn_about_state_name_collisions(function_name, extra_game_states)

						# Recorre _get_game_states(extra_game_states) y asigna cada elemento a state en cada vuelta.
						for state in _get_game_states(extra_game_states):
							# Comprueba _thing_has_method(state, function_name, args); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
							if _thing_has_method(state, function_name, args):
								# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
								token.type = DMConstants.TOKEN_VALUE
								# Guarda en token.value el resultado de await _resolve_thing_method(state, function_name, args).
								token.value = await _resolve_thing_method(state, function_name, args)
								# Guarda en found el resultado de true.
								found = true
								# Termina inmediatamente el bucle actual.
								break

				# Llama al metodo show_error_for_missing_state_value para realizar esta accion en este punto.
				show_error_for_missing_state_value(DMConstants.translate(&"runtime.method_not_found").format({
					# Guarda en method el resultado de args[0] if function_name in ["call", "call_deferred"] else function_name,.
					method = args[0] if function_name in ["call", "call_deferred"] else function_name,
					# Guarda en states el resultado de _get_state_shortcut_names(extra_game_states).
					states = _get_state_shortcut_names(extra_game_states)
				# Ejecuta esta instruccion: }), not found).
				}), not found)

		# Comprueba token.type == DMConstants.TOKEN_DICTIONARY_REFERENCE si las condiciones anteriores resultaron falsas.
		elif token.type == DMConstants.TOKEN_DICTIONARY_REFERENCE:
			# Declara value para guardar un dato utilizado por este script.
			var value
			# Comprueba i > 0 and tokens[i - 1].type == DMConstants.TOKEN_DOT; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if i > 0 and tokens[i - 1].type == DMConstants.TOKEN_DOT:
				# If we are deep referencing then we need to get the parent object.
				# `parent.value` is the actual object and `token.variable` is the name of
				# the property within it.
				value = tokens[i - 2].value[token.variable]
				# Clean up the previous tokens
				token.erase("variable")
				# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
				tokens.remove_at(i - 1)
				# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
				tokens.remove_at(i - 2)
				# Resta de i el valor 2 respecto de su valor anterior.
				i -= 2
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Otherwise we can just get this variable as a normal state reference
				value = _get_state_value(token.variable, extra_game_states)

			# Crea index e inicializa su valor con await _resolve(token.value, extra_game_states).
			var index = await _resolve(token.value, extra_game_states)
			# Comprueba typeof(value) == TYPE_DICTIONARY; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if typeof(value) == TYPE_DICTIONARY:
				# Comprueba tokens.size() > i + 1 and tokens[i + 1].type == DMConstants.TOKEN_ASSIGNMENT; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if tokens.size() > i + 1 and tokens[i + 1].type == DMConstants.TOKEN_ASSIGNMENT:
					# If the next token is an assignment then we need to leave this as a reference
					# so that it can be resolved once everything ahead of it has been resolved
					token.type = "dictionary"
					# Guarda en token.value el resultado de value.
					token.value = value
					# Guarda en token.key el resultado de index.
					token.key = index
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Comprueba value.has(index); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if value.has(index):
						# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
						token.type = DMConstants.TOKEN_VALUE
						# Guarda en token.value el resultado de value[index].
						token.value = value[index]
					# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
					else:
						# Llama al metodo show_error_for_missing_state_value para realizar esta accion en este punto.
						show_error_for_missing_state_value(DMConstants.translate(&"runtime.key_not_found").format({ key = str(index), dictionary = token.variable }))
			# Comprueba typeof(value) == TYPE_ARRAY si las condiciones anteriores resultaron falsas.
			elif typeof(value) == TYPE_ARRAY:
				# Comprueba tokens.size() > i + 1 and tokens[i + 1].type == DMConstants.TOKEN_ASSIGNMENT; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if tokens.size() > i + 1 and tokens[i + 1].type == DMConstants.TOKEN_ASSIGNMENT:
					# If the next token is an assignment then we need to leave this as a reference
					# so that it can be resolved once everything ahead of it has been resolved
					token.type = "array"
					# Guarda en token.value el resultado de value.
					token.value = value
					# Guarda en token.key el resultado de index.
					token.key = index
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Comprueba index >= 0 and index < value.size(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if index >= 0 and index < value.size():
						# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
						token.type = DMConstants.TOKEN_VALUE
						# Guarda en token.value el resultado de value[index].
						token.value = value[index]
					# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
					else:
						# Llama al metodo show_error_for_missing_state_value para realizar esta accion en este punto.
						show_error_for_missing_state_value(DMConstants.translate(&"runtime.array_index_out_of_bounds").format({ index = index, array = token.variable }))

		# Comprueba token.type == DMConstants.TOKEN_DICTIONARY_NESTED_REFERENCE si las condiciones anteriores resultaron falsas.
		elif token.type == DMConstants.TOKEN_DICTIONARY_NESTED_REFERENCE:
			# Crea dictionary e inicializa su valor con tokens[i - 1].
			var dictionary: Dictionary = tokens[i - 1]
			# Crea index e inicializa su valor con await _resolve(token.value, extra_game_states).
			var index = await _resolve(token.value, extra_game_states)
			# Crea value e inicializa su valor con dictionary.value.
			var value = dictionary.value
			# Comprueba typeof(value) == TYPE_DICTIONARY; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if typeof(value) == TYPE_DICTIONARY:
				# Comprueba tokens.size() > i + 1 and tokens[i + 1].type == DMConstants.TOKEN_ASSIGNMENT; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if tokens.size() > i + 1 and tokens[i + 1].type == DMConstants.TOKEN_ASSIGNMENT:
					# If the next token is an assignment then we need to leave this as a reference
					# so that it can be resolved once everything ahead of it has been resolved
					dictionary.type = "dictionary"
					# Guarda en dictionary.key el resultado de index.
					dictionary.key = index
					# Guarda en dictionary.value el resultado de value.
					dictionary.value = value
					# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
					tokens.remove_at(i)
					# Resta de i el valor 1 respecto de su valor anterior.
					i -= 1
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Comprueba dictionary.value.has(index); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if dictionary.value.has(index):
						# Guarda en dictionary.value el resultado de value.get(index).
						dictionary.value = value.get(index)
						# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
						tokens.remove_at(i)
						# Resta de i el valor 1 respecto de su valor anterior.
						i -= 1
					# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
					else:
						# Llama al metodo show_error_for_missing_state_value para realizar esta accion en este punto.
						show_error_for_missing_state_value(DMConstants.translate(&"runtime.key_not_found").format({ key = str(index), dictionary = value }))
			# Comprueba typeof(value) == TYPE_ARRAY si las condiciones anteriores resultaron falsas.
			elif typeof(value) == TYPE_ARRAY:
				# Comprueba tokens.size() > i + 1 and tokens[i + 1].type == DMConstants.TOKEN_ASSIGNMENT; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if tokens.size() > i + 1 and tokens[i + 1].type == DMConstants.TOKEN_ASSIGNMENT:
					# If the next token is an assignment then we need to leave this as a reference
					# so that it can be resolved once everything ahead of it has been resolved
					dictionary.type = "array"
					# Guarda en dictionary.value el resultado de value.
					dictionary.value = value
					# Guarda en dictionary.key el resultado de index.
					dictionary.key = index
					# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
					tokens.remove_at(i)
					# Resta de i el valor 1 respecto de su valor anterior.
					i -= 1
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Comprueba index >= 0 and index < value.size(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if index >= 0 and index < value.size():
						# Guarda en dictionary.value el resultado de value[index].
						dictionary.value = value[index]
						# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
						tokens.remove_at(i)
						# Resta de i el valor 1 respecto de su valor anterior.
						i -= 1
					# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
					else:
						# Llama al metodo show_error_for_missing_state_value para realizar esta accion en este punto.
						show_error_for_missing_state_value(DMConstants.translate(&"runtime.array_index_out_of_bounds").format({ index = index, array = value }))

		# Comprueba token.type == DMConstants.TOKEN_ARRAY si las condiciones anteriores resultaron falsas.
		elif token.type == DMConstants.TOKEN_ARRAY:
			# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
			token.type = DMConstants.TOKEN_VALUE
			# Guarda en token.value el resultado de await _resolve_each(token.value, extra_game_states).
			token.value = await _resolve_each(token.value, extra_game_states)

		# Comprueba token.type == DMConstants.TOKEN_DICTIONARY si las condiciones anteriores resultaron falsas.
		elif token.type == DMConstants.TOKEN_DICTIONARY:
			# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
			token.type = DMConstants.TOKEN_VALUE
			# Crea dictionary e inicializa su valor con {}.
			var dictionary = {}
			# Recorre token.value.keys() y asigna cada elemento a key en cada vuelta.
			for key in token.value.keys():
				# Crea resolved_key e inicializa su valor con await _resolve([key], extra_game_states).
				var resolved_key = await _resolve([key], extra_game_states)
				# Crea preresolved_value e inicializa su valor con token.value.get(key).
				var preresolved_value = token.value.get(key)
				# Comprueba typeof(preresolved_value) != TYPE_ARRAY; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if typeof(preresolved_value) != TYPE_ARRAY:
					# Guarda en preresolved_value el resultado de [preresolved_value].
					preresolved_value = [preresolved_value]
				# Crea resolved_value e inicializa su valor con await _resolve(preresolved_value, extra_game_states).
				var resolved_value = await _resolve(preresolved_value, extra_game_states)
				# Ejecuta esta instruccion: dictionary[resolved_key] = resolved_value.
				dictionary[resolved_key] = resolved_value
			# Guarda en token.value el resultado de dictionary.
			token.value = dictionary

		# Comprueba token.type == DMConstants.TOKEN_VARIABLE or token.type == DMConstants.TOKEN_NUMBER si las condiciones anteriores resultaron falsas.
		elif token.type == DMConstants.TOKEN_VARIABLE or token.type == DMConstants.TOKEN_NUMBER:
			# Comprueba str(token.value) == "null"; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if str(token.value) == "null":
				# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
				token.type = DMConstants.TOKEN_VALUE
				# Guarda en token.value el resultado de null.
				token.value = null
			# Comprueba str(token.value) == "self" si las condiciones anteriores resultaron falsas.
			elif str(token.value) == "self":
				# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
				token.type = DMConstants.TOKEN_VALUE
				# Guarda en token.value el resultado de extra_game_states[0].self.
				token.value = extra_game_states[0].self
			# Comprueba tokens[i - 1].type == DMConstants.TOKEN_DOT si las condiciones anteriores resultaron falsas.
			elif tokens[i - 1].type == DMConstants.TOKEN_DOT:
				# Crea caller e inicializa su valor con tokens[i - 2].
				var caller: Dictionary = tokens[i - 2]
				# Crea property e inicializa su valor con token.value.
				var property = token.value
				# Comprueba tokens.size() > i + 1 and tokens[i + 1].type == DMConstants.TOKEN_ASSIGNMENT; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if tokens.size() > i + 1 and tokens[i + 1].type == DMConstants.TOKEN_ASSIGNMENT:
					# If the next token is an assignment then we need to leave this as a reference
					# so that it can be resolved once everything ahead of it has been resolved
					caller.type = "property"
					# Guarda en caller.property el resultado de property.
					caller.property = property
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# If we are requesting a deeper property then we need to collapse the
					# value into the thing we are referencing from
					caller.type = DMConstants.TOKEN_VALUE
					# Comprueba Builtins.is_supported(caller.value); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if Builtins.is_supported(caller.value):
						# Guarda en caller.value el resultado de Builtins.resolve_property(caller.value, property).
						caller.value = Builtins.resolve_property(caller.value, property)
					# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
					else:
						# Guarda en caller.value el resultado de caller.value.get(property).
						caller.value = caller.value.get(property)
				# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
				tokens.remove_at(i)
				# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
				tokens.remove_at(i - 1)
				# Resta de i el valor 2 respecto de su valor anterior.
				i -= 2
			# Comprueba tokens.size() > i + 1 and tokens[i + 1].type == DMConstants.TOKEN_ASSIGNMENT si las condiciones anteriores resultaron falsas.
			elif tokens.size() > i + 1 and tokens[i + 1].type == DMConstants.TOKEN_ASSIGNMENT:
				# It's a normal variable but we will be assigning to it so don't resolve
				# it until everything after it has been resolved
				token.type = "variable"
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Comprueba token.type == DMConstants.TOKEN_NUMBER; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if token.type == DMConstants.TOKEN_NUMBER:
					# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
					token.type = DMConstants.TOKEN_VALUE
					# Guarda en token.value el resultado de token.value.
					token.value = token.value
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
					token.type = DMConstants.TOKEN_VALUE
					# Guarda en token.value el resultado de _get_state_value(str(token.value), extra_game_states).
					token.value = _get_state_value(str(token.value), extra_game_states)

		# Suma a i el valor 1 respecto de su valor anterior.
		i += 1

	# Then multiply and divide
	i = 0
	# Guarda en limit el resultado de 0.
	limit = 0
	# Repite este bloque mientras i < tokens.size() and limit < 1000 sea verdadero.
	while i < tokens.size() and limit < 1000:
		# Suma a limit el valor 1 respecto de su valor anterior.
		limit += 1
		# Crea token e inicializa su valor con tokens[i].
		var token: Dictionary = tokens[i]
		# Comprueba token.type == DMConstants.TOKEN_OPERATOR and token.value in ["*", "/", "%"]; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if token.type == DMConstants.TOKEN_OPERATOR and token.value in ["*", "/", "%"]:
			# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
			token.type = DMConstants.TOKEN_VALUE
			# Guarda en token.value el resultado de _apply_operation(token.value, tokens[i - 1].value, tokens[i + 1].value).
			token.value = _apply_operation(token.value, tokens[i - 1].value, tokens[i + 1].value)
			# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
			tokens.remove_at(i + 1)
			# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
			tokens.remove_at(i - 1)
			# Resta de i el valor 1 respecto de su valor anterior.
			i -= 1
		# Suma a i el valor 1 respecto de su valor anterior.
		i += 1

	# Comprueba limit >= 1000; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if limit >= 1000:
		# Llama al metodo assert para realizar esta accion en este punto.
		assert(false, DMConstants.translate(&"runtime.something_went_wrong"))

	# Then addition and subtraction
	i = 0
	# Guarda en limit el resultado de 0.
	limit = 0
	# Repite este bloque mientras i < tokens.size() and limit < 1000 sea verdadero.
	while i < tokens.size() and limit < 1000:
		# Suma a limit el valor 1 respecto de su valor anterior.
		limit += 1
		# Crea token e inicializa su valor con tokens[i].
		var token: Dictionary = tokens[i]
		# Comprueba token.type == DMConstants.TOKEN_OPERATOR and token.value in ["+", "-"]; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if token.type == DMConstants.TOKEN_OPERATOR and token.value in ["+", "-"]:
			# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
			token.type = DMConstants.TOKEN_VALUE
			# Guarda en token.value el resultado de _apply_operation(token.value, tokens[i - 1].value, tokens[i + 1].value).
			token.value = _apply_operation(token.value, tokens[i - 1].value, tokens[i + 1].value)
			# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
			tokens.remove_at(i + 1)
			# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
			tokens.remove_at(i - 1)
			# Resta de i el valor 1 respecto de su valor anterior.
			i -= 1
		# Suma a i el valor 1 respecto de su valor anterior.
		i += 1

	# Comprueba limit >= 1000; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if limit >= 1000:
		# Llama al metodo assert para realizar esta accion en este punto.
		assert(false, DMConstants.translate(&"runtime.something_went_wrong"))

	# Then negations
	i = 0
	# Guarda en limit el resultado de 0.
	limit = 0
	# Repite este bloque mientras i < tokens.size() and limit < 1000 sea verdadero.
	while i < tokens.size() and limit < 1000:
		# Suma a limit el valor 1 respecto de su valor anterior.
		limit += 1
		# Crea token e inicializa su valor con tokens[i].
		var token: Dictionary = tokens[i]
		# Comprueba token.type == DMConstants.TOKEN_NOT; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if token.type == DMConstants.TOKEN_NOT:
			# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
			token.type = DMConstants.TOKEN_VALUE
			# Guarda en token.value el resultado de not tokens[i + 1].value.
			token.value = not tokens[i + 1].value
			# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
			tokens.remove_at(i + 1)
			# Resta de i el valor 1 respecto de su valor anterior.
			i -= 1
		# Suma a i el valor 1 respecto de su valor anterior.
		i += 1

	# Comprueba limit >= 1000; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if limit >= 1000:
		# Llama al metodo assert para realizar esta accion en este punto.
		assert(false, DMConstants.translate(&"runtime.something_went_wrong"))

	# Then comparisons
	i = 0
	# Guarda en limit el resultado de 0.
	limit = 0
	# Repite este bloque mientras i < tokens.size() and limit < 1000 sea verdadero.
	while i < tokens.size() and limit < 1000:
		# Suma a limit el valor 1 respecto de su valor anterior.
		limit += 1
		# Crea token e inicializa su valor con tokens[i].
		var token: Dictionary = tokens[i]
		# Comprueba token.type == DMConstants.TOKEN_COMPARISON; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if token.type == DMConstants.TOKEN_COMPARISON:
			# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
			token.type = DMConstants.TOKEN_VALUE
			# Guarda en token.value el resultado de _compare(token.value, tokens[i - 1].value, tokens[i + 1].value).
			token.value = _compare(token.value, tokens[i - 1].value, tokens[i + 1].value)
			# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
			tokens.remove_at(i + 1)
			# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
			tokens.remove_at(i - 1)
			# Resta de i el valor 1 respecto de su valor anterior.
			i -= 1
		# Suma a i el valor 1 respecto de su valor anterior.
		i += 1

	# Comprueba limit >= 1000; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if limit >= 1000:
		# Llama al metodo assert para realizar esta accion en este punto.
		assert(false, DMConstants.translate(&"runtime.something_went_wrong"))

	# Then and/or
	i = 0
	# Guarda en limit el resultado de 0.
	limit = 0
	# Repite este bloque mientras i < tokens.size() and limit < 1000 sea verdadero.
	while i < tokens.size() and limit < 1000:
		# Suma a limit el valor 1 respecto de su valor anterior.
		limit += 1
		# Crea token e inicializa su valor con tokens[i].
		var token: Dictionary = tokens[i]
		# Comprueba token.type == DMConstants.TOKEN_AND_OR; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if token.type == DMConstants.TOKEN_AND_OR:
			# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
			token.type = DMConstants.TOKEN_VALUE
			# Guarda en token.value el resultado de _apply_operation(token.value, tokens[i - 1].value, tokens[i + 1].value).
			token.value = _apply_operation(token.value, tokens[i - 1].value, tokens[i + 1].value)
			# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
			tokens.remove_at(i + 1)
			# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
			tokens.remove_at(i - 1)
			# Resta de i el valor 1 respecto de su valor anterior.
			i -= 1
		# Suma a i el valor 1 respecto de su valor anterior.
		i += 1

	# Comprueba limit >= 1000; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if limit >= 1000:
		# Llama al metodo assert para realizar esta accion en este punto.
		assert(false, DMConstants.translate(&"runtime.something_went_wrong"))

	# Lastly, resolve any assignments
	i = 0
	# Guarda en limit el resultado de 0.
	limit = 0
	# Repite este bloque mientras i < tokens.size() and limit < 1000 sea verdadero.
	while i < tokens.size() and limit < 1000:
		# Suma a limit el valor 1 respecto de su valor anterior.
		limit += 1
		# Crea token e inicializa su valor con tokens[i].
		var token: Dictionary = tokens[i]
		# Comprueba token.type == DMConstants.TOKEN_ASSIGNMENT; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if token.type == DMConstants.TOKEN_ASSIGNMENT:
			# Crea lhs e inicializa su valor con tokens[i - 1].
			var lhs: Dictionary = tokens[i - 1]
			# Declara value para guardar un dato utilizado por este script.
			var value

			# Compara lhs.type con los casos siguientes y ejecuta el que coincida.
			match lhs.type:
				# Ejecuta esta instruccion: &"variable":.
				&"variable":
					# Guarda en value el resultado de _apply_operation(token.value, _get_state_value(lhs.value, extra_game_states), tokens[i + 1].value).
					value = _apply_operation(token.value, _get_state_value(lhs.value, extra_game_states), tokens[i + 1].value)
					# Llama al metodo _set_state_value para realizar esta accion en este punto.
					_set_state_value(lhs.value, value, extra_game_states)
				# Ejecuta esta instruccion: &"property":.
				&"property":
					# Guarda en value el resultado de _apply_operation(token.value, lhs.value.get(lhs.property), tokens[i + 1].value).
					value = _apply_operation(token.value, lhs.value.get(lhs.property), tokens[i + 1].value)
					# Comprueba typeof(lhs.value) == TYPE_DICTIONARY; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
					if typeof(lhs.value) == TYPE_DICTIONARY:
						# Ejecuta esta instruccion: lhs.value[lhs.property] = value.
						lhs.value[lhs.property] = value
					# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
					else:
						# Llama al metodo lhs.value.set para realizar esta accion en este punto.
						lhs.value.set(lhs.property, value)
				# Ejecuta esta instruccion: &"dictionary":.
				&"dictionary":
					# Guarda en value el resultado de _apply_operation(token.value, lhs.value.get(lhs.key, null), tokens[i + 1].value).
					value = _apply_operation(token.value, lhs.value.get(lhs.key, null), tokens[i + 1].value)
					# Ejecuta esta instruccion: lhs.value[lhs.key] = value.
					lhs.value[lhs.key] = value
				# Ejecuta esta instruccion: &"array":.
				&"array":
					# Llama al metodo show_error_for_missing_state_value para realizar esta accion en este punto.
					show_error_for_missing_state_value(
						# Llama al metodo DMConstants.translate para realizar esta accion en este punto.
						DMConstants.translate(&"runtime.array_index_out_of_bounds").format({ index = lhs.key, array = lhs.value }),
						# Ejecuta esta instruccion: lhs.key >= lhs.value.size().
						lhs.key >= lhs.value.size()
					)
					# Guarda en value el resultado de _apply_operation(token.value, lhs.value[lhs.key], tokens[i + 1].value).
					value = _apply_operation(token.value, lhs.value[lhs.key], tokens[i + 1].value)
					# Ejecuta esta instruccion: lhs.value[lhs.key] = value.
					lhs.value[lhs.key] = value
				# Asocia la clave _ con  dentro del diccionario.
				_:
					# Llama al metodo show_error_for_missing_state_value para realizar esta accion en este punto.
					show_error_for_missing_state_value(DMConstants.translate(&"runtime.left_hand_size_cannot_be_assigned_to"))

			# Guarda en token.type el resultado de DMConstants.TOKEN_VALUE.
			token.type = DMConstants.TOKEN_VALUE
			# Guarda en token.value el resultado de value.
			token.value = value
			# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
			tokens.remove_at(i + 1)
			# Llama al metodo tokens.remove_at para realizar esta accion en este punto.
			tokens.remove_at(i - 1)
			# Resta de i el valor 1 respecto de su valor anterior.
			i -= 1
		# Suma a i el valor 1 respecto de su valor anterior.
		i += 1

	# Comprueba limit >= 1000; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if limit >= 1000:
		# Llama al metodo assert para realizar esta accion en este punto.
		assert(false, DMConstants.translate(&"runtime.something_went_wrong"))

	# Termina el metodo y devuelve tokens[0].value a quien lo llamo.
	return tokens[0].value


# Compare two values.
func _compare(operator: String, first_value, second_value) -> bool:
	# Compara operator con los casos siguientes y ejecuta el que coincida.
	match operator:
		# Ejecuta esta instruccion: &"in":.
		&"in":
			# Comprueba first_value == null or second_value == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if first_value == null or second_value == null:
				# Termina el metodo y devuelve false a quien lo llamo.
				return false
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Termina el metodo y devuelve first_value in second_value a quien lo llamo.
				return first_value in second_value
		# Ejecuta esta instruccion: &"<":.
		&"<":
			# Comprueba first_value == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if first_value == null:
				# Termina el metodo y devuelve true a quien lo llamo.
				return true
			# Comprueba second_value == null si las condiciones anteriores resultaron falsas.
			elif second_value == null:
				# Termina el metodo y devuelve false a quien lo llamo.
				return false
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Termina el metodo y devuelve first_value < second_value a quien lo llamo.
				return first_value < second_value
		# Ejecuta esta instruccion: &">":.
		&">":
			# Comprueba first_value == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if first_value == null:
				# Termina el metodo y devuelve false a quien lo llamo.
				return false
			# Comprueba second_value == null si las condiciones anteriores resultaron falsas.
			elif second_value == null:
				# Termina el metodo y devuelve true a quien lo llamo.
				return true
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Termina el metodo y devuelve first_value > second_value a quien lo llamo.
				return first_value > second_value
		# Ejecuta esta instruccion: &"<=":.
		&"<=":
			# Comprueba first_value == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if first_value == null:
				# Termina el metodo y devuelve true a quien lo llamo.
				return true
			# Comprueba second_value == null si las condiciones anteriores resultaron falsas.
			elif second_value == null:
				# Termina el metodo y devuelve false a quien lo llamo.
				return false
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Termina el metodo y devuelve first_value <= second_value a quien lo llamo.
				return first_value <= second_value
		# Ejecuta esta instruccion: &">=":.
		&">=":
			# Comprueba first_value == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if first_value == null:
				# Termina el metodo y devuelve false a quien lo llamo.
				return false
			# Comprueba second_value == null si las condiciones anteriores resultaron falsas.
			elif second_value == null:
				# Termina el metodo y devuelve true a quien lo llamo.
				return true
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Termina el metodo y devuelve first_value >= second_value a quien lo llamo.
				return first_value >= second_value
		# Ejecuta esta instruccion: &"==":.
		&"==":
			# Comprueba first_value == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if first_value == null:
				# Comprueba typeof(second_value) == TYPE_BOOL; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if typeof(second_value) == TYPE_BOOL:
					# Termina el metodo y devuelve second_value == false a quien lo llamo.
					return second_value == false
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Termina el metodo y devuelve second_value == null a quien lo llamo.
					return second_value == null
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Termina el metodo y devuelve first_value == second_value a quien lo llamo.
				return first_value == second_value
		# Ejecuta esta instruccion: &"!=":.
		&"!=":
			# Comprueba first_value == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if first_value == null:
				# Comprueba typeof(second_value) == TYPE_BOOL; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
				if typeof(second_value) == TYPE_BOOL:
					# Termina el metodo y devuelve second_value == true a quien lo llamo.
					return second_value == true
				# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
				else:
					# Termina el metodo y devuelve second_value != null a quien lo llamo.
					return second_value != null
			# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
			else:
				# Termina el metodo y devuelve first_value != second_value a quien lo llamo.
				return first_value != second_value

	# Termina el metodo y devuelve false a quien lo llamo.
	return false


# Apply an operation from one value to another.
func _apply_operation(operator: String, first_value, second_value):
	# Compara operator con los casos siguientes y ejecuta el que coincida.
	match operator:
		# Ejecuta esta instruccion: &"=":.
		&"=":
			# Termina el metodo y devuelve second_value a quien lo llamo.
			return second_value
		# Ejecuta esta instruccion: &"+", &"+=":.
		&"+", &"+=":
			# Termina el metodo y devuelve first_value + second_value a quien lo llamo.
			return first_value + second_value
		# Ejecuta esta instruccion: &"-", &"-=":.
		&"-", &"-=":
			# Termina el metodo y devuelve first_value - second_value a quien lo llamo.
			return first_value - second_value
		# Ejecuta esta instruccion: &"/", &"/=":.
		&"/", &"/=":
			# Termina el metodo y devuelve first_value / second_value a quien lo llamo.
			return first_value / second_value
		# Ejecuta esta instruccion: &"*", &"*=":.
		&"*", &"*=":
			# Termina el metodo y devuelve first_value * second_value a quien lo llamo.
			return first_value * second_value
		# Ejecuta esta instruccion: &"%":.
		&"%":
			# Termina el metodo y devuelve first_value % second_value a quien lo llamo.
			return first_value % second_value
		# Ejecuta esta instruccion: &"and":.
		&"and":
			# Termina el metodo y devuelve first_value and second_value a quien lo llamo.
			return first_value and second_value
		# Ejecuta esta instruccion: &"or":.
		&"or":
			# Termina el metodo y devuelve first_value or second_value a quien lo llamo.
			return first_value or second_value

	# Llama al metodo assert para realizar esta accion en este punto.
	assert(false, DMConstants.translate(&"runtime.unknown_operator"))


# Check if a dialogue line contains meaningful information.
func _is_valid(line: DialogueLine) -> bool:
	# Comprueba line == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if line == null:
		# Termina el metodo y devuelve false a quien lo llamo.
		return false
	# Comprueba line.type == DMConstants.TYPE_MUTATION and line.mutation == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if line.type == DMConstants.TYPE_MUTATION and line.mutation == null:
		# Termina el metodo y devuelve false a quien lo llamo.
		return false
	# Comprueba line.type == DMConstants.TYPE_RESPONSE and line.get(&"responses").size() == 0; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if line.type == DMConstants.TYPE_RESPONSE and line.get(&"responses").size() == 0:
		# Termina el metodo y devuelve false a quien lo llamo.
		return false
	# Termina el metodo y devuelve true a quien lo llamo.
	return true


# Check that a thing has a given method.
func _thing_has_method(thing, method: String, args: Array) -> bool:
	# Comprueba not is_instance_valid(thing); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not is_instance_valid(thing):
		# Termina el metodo y devuelve false a quien lo llamo.
		return false

	# Comprueba Builtins.is_supported(thing, method); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if Builtins.is_supported(thing, method):
		# Termina el metodo y devuelve thing != _autoloads a quien lo llamo.
		return thing != _autoloads
	# Comprueba thing is Dictionary si las condiciones anteriores resultaron falsas.
	elif thing is Dictionary:
		# Termina el metodo y devuelve false a quien lo llamo.
		return false

	# Comprueba method in [&"call", &"call_deferred"]; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if method in [&"call", &"call_deferred"]:
		# Termina el metodo y devuelve thing.has_method(args[0]) a quien lo llamo.
		return thing.has_method(args[0])

	# Comprueba method == &"emit_signal"; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if method == &"emit_signal":
		# Termina el metodo y devuelve thing.has_signal(args[0]) a quien lo llamo.
		return thing.has_signal(args[0])

	# Comprueba thing.has_method(method); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if thing.has_method(method):
		# Termina el metodo y devuelve true a quien lo llamo.
		return true

	# Comprueba thing.get_script() and thing.get_script().resource_path.ends_with(".cs"); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if thing.get_script() and thing.get_script().resource_path.ends_with(".cs"):
		# If we get this far then the method might be a C# method with a Task return type
		return _get_dotnet_dialogue_manager().ThingHasMethod(thing, method, args)

	# Termina el metodo y devuelve false a quien lo llamo.
	return false


# Check if a given property exists
func _thing_has_property(thing: Object, property: String) -> bool:
	# Comprueba thing == null; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if thing == null:
		# Termina el metodo y devuelve false a quien lo llamo.
		return false

	# Recorre thing.get_property_list() y asigna cada elemento a p en cada vuelta.
	for p in thing.get_property_list():
		# Comprueba _node_properties.has(p.name); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if _node_properties.has(p.name):
			# Ignore any properties on the base Node
			continue
		# Comprueba p.name == property; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if p.name == property:
			# Termina el metodo y devuelve true a quien lo llamo.
			return true

	# Termina el metodo y devuelve false a quien lo llamo.
	return false


# Define el metodo _get_method_info_for para agrupar esta accion del script.
func _get_method_info_for(thing: Variant, method: String, args: Array) -> Dictionary:
	# Use the thing instance id as a key for the caching dictionary.
	var thing_instance_id: int = thing.get_instance_id()
	# Comprueba not _method_info_cache.has(thing_instance_id); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not _method_info_cache.has(thing_instance_id):
		# Crea methods e inicializa su valor con {}.
		var methods: Dictionary = {}
		# Recorre thing.get_method_list() y asigna cada elemento a m en cada vuelta.
		for m in thing.get_method_list():
			# Ejecuta esta instruccion: methods["%s:%d" % [m.name, m.args.size()]] = m.
			methods["%s:%d" % [m.name, m.args.size()]] = m
			# Comprueba not methods.has(m.name); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if not methods.has(m.name):
				# Ejecuta esta instruccion: methods[m.name] = m.
				methods[m.name] = m
		# Ejecuta esta instruccion: _method_info_cache[thing_instance_id] = methods.
		_method_info_cache[thing_instance_id] = methods

	# Crea methods e inicializa su valor con _method_info_cache.get(thing_instance_id, {}).
	var methods: Dictionary = _method_info_cache.get(thing_instance_id, {})
	# Crea method_key e inicializa su valor con "%s:%d" % [method, args.size()].
	var method_key: String = "%s:%d" % [method, args.size()]
	# Comprueba methods.has(method_key); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if methods.has(method_key):
		# Termina el metodo y devuelve methods.get(method_key) a quien lo llamo.
		return methods.get(method_key)
	# Ejecuta la alternativa cuando ninguna condicion anterior se cumplio.
	else:
		# Termina el metodo y devuelve methods.get(method) a quien lo llamo.
		return methods.get(method)


# Define el metodo _resolve_thing_method para agrupar esta accion del script.
func _resolve_thing_method(thing, method: String, args: Array):
	# Comprueba Builtins.is_supported(thing); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if Builtins.is_supported(thing):
		# Crea result e inicializa su valor con Builtins.resolve_method(thing, method, args).
		var result = Builtins.resolve_method(thing, method, args)
		# Comprueba not Builtins.has_resolve_method_failed(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if not Builtins.has_resolve_method_failed():
			# Termina el metodo y devuelve result a quien lo llamo.
			return result

	# Comprueba thing.has_method(method); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if thing.has_method(method):
		# Try to convert any literals to the right type
		var method_info: Dictionary = _get_method_info_for(thing, method, args)
		# Crea method_args e inicializa su valor con method_info.args.
		var method_args: Array = method_info.args
		# Comprueba method_info.flags & METHOD_FLAG_VARARG == 0 and method_args.size() < args.size(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if method_info.flags & METHOD_FLAG_VARARG == 0 and method_args.size() < args.size():
			# Llama al metodo assert para realizar esta accion en este punto.
			assert(false, DMConstants.translate(&"runtime.expected_n_got_n_args").format({ expected = method_args.size(), method = method, received = args.size()}))
		# Recorre range(0, min(method_args.size(), args.size())) y asigna cada elemento a i en cada vuelta.
		for i in range(0, min(method_args.size(), args.size())):
			# Crea m e inicializa su valor con method_args[i].
			var m: Dictionary = method_args[i]
			# Crea to_type e inicializa su valor con typeof(args[i]).
			var to_type: int = typeof(args[i])
			# Comprueba m.type == TYPE_ARRAY; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if m.type == TYPE_ARRAY:
				# Compara m.hint_string con los casos siguientes y ejecuta el que coincida.
				match m.hint_string:
					# Ejecuta esta instruccion: &"String":.
					&"String":
						# Guarda en to_type el resultado de TYPE_PACKED_STRING_ARRAY.
						to_type = TYPE_PACKED_STRING_ARRAY
					# Ejecuta esta instruccion: &"int":.
					&"int":
						# Guarda en to_type el resultado de TYPE_PACKED_INT64_ARRAY.
						to_type = TYPE_PACKED_INT64_ARRAY
					# Ejecuta esta instruccion: &"float":.
					&"float":
						# Guarda en to_type el resultado de TYPE_PACKED_FLOAT64_ARRAY.
						to_type = TYPE_PACKED_FLOAT64_ARRAY
					# Ejecuta esta instruccion: &"Vector2":.
					&"Vector2":
						# Guarda en to_type el resultado de TYPE_PACKED_VECTOR2_ARRAY.
						to_type = TYPE_PACKED_VECTOR2_ARRAY
					# Ejecuta esta instruccion: &"Vector3":.
					&"Vector3":
						# Guarda en to_type el resultado de TYPE_PACKED_VECTOR3_ARRAY.
						to_type = TYPE_PACKED_VECTOR3_ARRAY
					# Asocia la clave _ con  dentro del diccionario.
					_:
						# Comprueba m.hint_string != ""; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
						if m.hint_string != "":
							# Llama al metodo assert para realizar esta accion en este punto.
							assert(false, DMConstants.translate(&"runtime.unsupported_array_type").format({ type = m.hint_string}))
			# Comprueba typeof(args[i]) != to_type; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
			if typeof(args[i]) != to_type:
				# Ejecuta esta instruccion: args[i] = convert(args[i], to_type).
				args[i] = convert(args[i], to_type)

		# Termina el metodo y devuelve await thing.callv(method, args) a quien lo llamo.
		return await thing.callv(method, args)

	# If we get here then it's probably a C# method with a Task return type
	var dotnet_dialogue_manager = _get_dotnet_dialogue_manager()
	# Llama al metodo dotnet_dialogue_manager.ResolveThingMethod para realizar esta accion en este punto.
	dotnet_dialogue_manager.ResolveThingMethod(thing, method, args)
	# Termina el metodo y devuelve await dotnet_dialogue_manager.Resolved a quien lo llamo.
	return await dotnet_dialogue_manager.Resolved
