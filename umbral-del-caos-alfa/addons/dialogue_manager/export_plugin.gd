# Registra DMExportPlugin como nombre de clase global para usarlo en otros scripts.
class_name DMExportPlugin extends EditorExportPlugin

# Define IGNORED_PATHS con el valor fijo [.
const IGNORED_PATHS = [
	# Ejecuta esta instruccion: "/assets",.
	"/assets",
	# Ejecuta esta instruccion: "/components",.
	"/components",
	# Ejecuta esta instruccion: "/views",.
	"/views",
	# Ejecuta esta instruccion: "inspector_plugin",.
	"inspector_plugin",
	# Ejecuta esta instruccion: "test_scene".
	"test_scene"
]


# Define el metodo _get_name para agrupar esta accion del script.
func _get_name() -> String:
	# Termina el metodo y devuelve "Dialogue Manager Export Plugin" a quien lo llamo.
	return "Dialogue Manager Export Plugin"


# Define el metodo _export_file para agrupar esta accion del script.
func _export_file(path: String, type: String, features: PackedStringArray) -> void:
	# Crea plugin_path e inicializa su valor con Engine.get_meta("DialogueManagerPlugin").get_plugin_path().
	var plugin_path: String = Engine.get_meta("DialogueManagerPlugin").get_plugin_path()

	# Ignore any editor stuff
	for ignored_path: String in IGNORED_PATHS:
		# Comprueba path.begins_with(plugin_path + ignored_path); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
		if path.begins_with(plugin_path + ignored_path):
			# Llama al metodo skip para realizar esta accion en este punto.
			skip()

	# Ignore C# stuff it not using dotnet
	if path.begins_with(plugin_path) and not DMSettings.check_for_dotnet_solution() and path.ends_with(".cs"):
		# Llama al metodo skip para realizar esta accion en este punto.
		skip()
