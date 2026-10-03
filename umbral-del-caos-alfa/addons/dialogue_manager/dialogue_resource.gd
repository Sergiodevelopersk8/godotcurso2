# Ejecuta esta instruccion: @tool.
@tool
# Ejecuta esta instruccion: @icon("./assets/icon.svg").
@icon("./assets/icon.svg")

## A collection of dialogue lines for use with [code]DialogueManager[/code].
class_name DialogueResource extends Resource


# Define DialogueLine con el valor fijo preload("./dialogue_line.gd").
const DialogueLine = preload("./dialogue_line.gd")

## A list of state shortcuts
@export var using_states: PackedStringArray = []

## A map of titles and the lines they point to.
@export var titles: Dictionary = {}

## A list of character names.
@export var character_names: PackedStringArray = []

## The first title in the file.
@export var first_title: String = ""

## A map of the encoded lines of dialogue.
@export var lines: Dictionary = {}

## raw version of the text
@export var raw_text: String


## Get the next printable line of dialogue, starting from a referenced line ([code]title[/code] can
## be a title string or a stringified line number). Runs any mutations along the way and then returns
## the first dialogue line encountered.
func get_next_dialogue_line(title: String = "", extra_game_states: Array = [], mutation_behaviour: DMConstants.MutationBehaviour = DMConstants.MutationBehaviour.Wait) -> DialogueLine:
	# Termina el metodo y devuelve await Engine.get_singleton("DialogueManager").get_next_dialogue_line(self, title, extra_game_states, mutation_behaviour) a quien lo llamo.
	return await Engine.get_singleton("DialogueManager").get_next_dialogue_line(self, title, extra_game_states, mutation_behaviour)


## Get the list of any titles found in the file.
func get_titles() -> PackedStringArray:
	# Termina el metodo y devuelve titles.keys() a quien lo llamo.
	return titles.keys()


# Define el metodo _to_string para agrupar esta accion del script.
func _to_string() -> String:
	# Termina el metodo y devuelve "<DialogueResource titles=\"%s\">" % [",".join(titles.keys())] a quien lo llamo.
	return "<DialogueResource titles=\"%s\">" % [",".join(titles.keys())]
