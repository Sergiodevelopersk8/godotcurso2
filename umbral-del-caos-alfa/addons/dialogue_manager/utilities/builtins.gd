# Hereda de Object y reutiliza sus propiedades y comportamiento base.
extends Object


# Define DialogueConstants con el valor fijo preload("../constants.gd").
const DialogueConstants = preload("../constants.gd")

# Define SUPPORTED_BUILTIN_TYPES con el valor fijo [.
const SUPPORTED_BUILTIN_TYPES = [
	# Ejecuta esta instruccion: TYPE_STRING,.
	TYPE_STRING,
	# Ejecuta esta instruccion: TYPE_STRING_NAME,.
	TYPE_STRING_NAME,
	# Ejecuta esta instruccion: TYPE_ARRAY,.
	TYPE_ARRAY,
	# Ejecuta esta instruccion: TYPE_PACKED_STRING_ARRAY,.
	TYPE_PACKED_STRING_ARRAY,
	# Ejecuta esta instruccion: TYPE_VECTOR2,.
	TYPE_VECTOR2,
	# Ejecuta esta instruccion: TYPE_VECTOR3,.
	TYPE_VECTOR3,
	# Ejecuta esta instruccion: TYPE_VECTOR4,.
	TYPE_VECTOR4,
	# Ejecuta esta instruccion: TYPE_DICTIONARY,.
	TYPE_DICTIONARY,
	# Ejecuta esta instruccion: TYPE_QUATERNION,.
	TYPE_QUATERNION,
	# Ejecuta esta instruccion: TYPE_COLOR,.
	TYPE_COLOR,
	# Ejecuta esta instruccion: TYPE_SIGNAL,.
	TYPE_SIGNAL,
	# Ejecuta esta instruccion: TYPE_CALLABLE.
	TYPE_CALLABLE
]


# Ejecuta esta instruccion: static var resolve_method_error: Error = OK.
static var resolve_method_error: Error = OK


# Ejecuta esta instruccion: static func is_supported(thing, with_method: String = "") -> bool:.
static func is_supported(thing, with_method: String = "") -> bool:
	# Ejecuta esta instruccion: if not typeof(thing) in SUPPORTED_BUILTIN_TYPES: return false.
	if not typeof(thing) in SUPPORTED_BUILTIN_TYPES: return false

	# If given a Dictionary and a method then make sure it's a known Dictionary method.
	if typeof(thing) == TYPE_DICTIONARY and with_method != "":
		# Termina el metodo y devuelve with_method in [ a quien lo llamo.
		return with_method in [
			# Ejecuta esta instruccion: &"clear",.
			&"clear",
			# Ejecuta esta instruccion: &"duplicate",.
			&"duplicate",
			# Ejecuta esta instruccion: &"erase",.
			&"erase",
			# Ejecuta esta instruccion: &"find_key",.
			&"find_key",
			# Ejecuta esta instruccion: &"get",.
			&"get",
			# Ejecuta esta instruccion: &"get_or_add",.
			&"get_or_add",
			# Ejecuta esta instruccion: &"has",.
			&"has",
			# Ejecuta esta instruccion: &"has_all",.
			&"has_all",
			# Ejecuta esta instruccion: &"hash",.
			&"hash",
			# Ejecuta esta instruccion: &"is_empty",.
			&"is_empty",
			# Ejecuta esta instruccion: &"is_read_only",.
			&"is_read_only",
			# Ejecuta esta instruccion: &"keys",.
			&"keys",
			# Ejecuta esta instruccion: &"make_read_only",.
			&"make_read_only",
			# Ejecuta esta instruccion: &"merge",.
			&"merge",
			# Ejecuta esta instruccion: &"merged",.
			&"merged",
			# Ejecuta esta instruccion: &"recursive_equal",.
			&"recursive_equal",
			# Ejecuta esta instruccion: &"size",.
			&"size",
			# Ejecuta esta instruccion: &"values"].
			&"values"]

	# Termina el metodo y devuelve true a quien lo llamo.
	return true


# Ejecuta esta instruccion: static func resolve_property(builtin, property: String):.
static func resolve_property(builtin, property: String):
	# Compara typeof(builtin) con los casos siguientes y ejecuta el que coincida.
	match typeof(builtin):
		# Ejecuta esta instruccion: TYPE_ARRAY, TYPE_PACKED_STRING_ARRAY, TYPE_DICTIONARY, TYPE_QUATERNION, TYPE_STRING, TYPE_STRING_NAME:.
		TYPE_ARRAY, TYPE_PACKED_STRING_ARRAY, TYPE_DICTIONARY, TYPE_QUATERNION, TYPE_STRING, TYPE_STRING_NAME:
			# Termina el metodo y devuelve builtin[property] a quien lo llamo.
			return builtin[property]

		# Some types have constants that we need to manually resolve

		# Asocia la clave TYPE_VECTOR2 con  dentro del diccionario.
		TYPE_VECTOR2:
			# Termina el metodo y devuelve resolve_vector2_property(builtin, property) a quien lo llamo.
			return resolve_vector2_property(builtin, property)
		# Asocia la clave TYPE_VECTOR3 con  dentro del diccionario.
		TYPE_VECTOR3:
			# Termina el metodo y devuelve resolve_vector3_property(builtin, property) a quien lo llamo.
			return resolve_vector3_property(builtin, property)
		# Asocia la clave TYPE_VECTOR4 con  dentro del diccionario.
		TYPE_VECTOR4:
			# Termina el metodo y devuelve resolve_vector4_property(builtin, property) a quien lo llamo.
			return resolve_vector4_property(builtin, property)
		# Asocia la clave TYPE_COLOR con  dentro del diccionario.
		TYPE_COLOR:
			# Termina el metodo y devuelve resolve_color_property(builtin, property) a quien lo llamo.
			return resolve_color_property(builtin, property)


# Ejecuta esta instruccion: static func resolve_method(thing, method_name: String, args: Array):.
static func resolve_method(thing, method_name: String, args: Array):
	# Guarda en resolve_method_error el resultado de OK.
	resolve_method_error = OK

	# Resolve static methods manually
	match typeof(thing):
		# Asocia la clave TYPE_VECTOR2 con  dentro del diccionario.
		TYPE_VECTOR2:
			# Compara method_name con los casos siguientes y ejecuta el que coincida.
			match method_name:
				# Asocia la clave "from_angle" con  dentro del diccionario.
				"from_angle":
					# Termina el metodo y devuelve Vector2.from_angle(args[0]) a quien lo llamo.
					return Vector2.from_angle(args[0])

		# Asocia la clave TYPE_COLOR con  dentro del diccionario.
		TYPE_COLOR:
			# Compara method_name con los casos siguientes y ejecuta el que coincida.
			match method_name:
				# Asocia la clave "from_hsv" con  dentro del diccionario.
				"from_hsv":
					# Termina el metodo y devuelve Color.from_hsv(args[0], args[1], args[2]) if args.size() == 3 else Color.from_hsv(args[0], args[1], args[2], args[3]) a quien lo llamo.
					return Color.from_hsv(args[0], args[1], args[2]) if args.size() == 3 else Color.from_hsv(args[0], args[1], args[2], args[3])
				# Asocia la clave "from_ok_hsl" con  dentro del diccionario.
				"from_ok_hsl":
					# Termina el metodo y devuelve Color.from_ok_hsl(args[0], args[1], args[2]) if args.size() == 3 else Color.from_ok_hsl(args[0], args[1], args[2], args[3]) a quien lo llamo.
					return Color.from_ok_hsl(args[0], args[1], args[2]) if args.size() == 3 else Color.from_ok_hsl(args[0], args[1], args[2], args[3])
				# Asocia la clave "from_rgbe9995" con  dentro del diccionario.
				"from_rgbe9995":
					# Termina el metodo y devuelve Color.from_rgbe9995(args[0]) a quien lo llamo.
					return Color.from_rgbe9995(args[0])
				# Asocia la clave "from_string" con  dentro del diccionario.
				"from_string":
					# Termina el metodo y devuelve Color.from_string(args[0], args[1]) a quien lo llamo.
					return Color.from_string(args[0], args[1])

		# Asocia la clave TYPE_QUATERNION con  dentro del diccionario.
		TYPE_QUATERNION:
			# Compara method_name con los casos siguientes y ejecuta el que coincida.
			match method_name:
				# Asocia la clave "from_euler" con  dentro del diccionario.
				"from_euler":
					# Termina el metodo y devuelve Quaternion.from_euler(args[0]) a quien lo llamo.
					return Quaternion.from_euler(args[0])

	# Anything else can be evaulatated automatically
	var references: Array = ["thing"]
	# Recorre range(0, args.size()) y asigna cada elemento a i en cada vuelta.
	for i in range(0, args.size()):
		# Llama al metodo references.append para realizar esta accion en este punto.
		references.append("arg%d" % i)
	# Crea expression e inicializa su valor con Expression.new().
	var expression = Expression.new()
	# Comprueba expression.parse("thing.%s(%s)" % [method_name, ",".join(references.slice(1))], references) != OK; ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if expression.parse("thing.%s(%s)" % [method_name, ",".join(references.slice(1))], references) != OK:
		# Llama al metodo assert para realizar esta accion en este punto.
		assert(false, expression.get_error_text())
	# Crea result e inicializa su valor con expression.execute([thing] + args, null, false).
	var result = expression.execute([thing] + args, null, false)
	# Comprueba expression.has_execute_failed(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if expression.has_execute_failed():
		# Guarda en resolve_method_error el resultado de ERR_CANT_RESOLVE.
		resolve_method_error = ERR_CANT_RESOLVE
		# Termina el metodo y devuelve null a quien lo llamo.
		return null

	# Termina el metodo y devuelve result a quien lo llamo.
	return result


# Ejecuta esta instruccion: static func has_resolve_method_failed() -> bool:.
static func has_resolve_method_failed() -> bool:
	# Termina el metodo y devuelve resolve_method_error != OK a quien lo llamo.
	return resolve_method_error != OK


# Ejecuta esta instruccion: static func resolve_color_property(color: Color, property: String):.
static func resolve_color_property(color: Color, property: String):
	# Compara property con los casos siguientes y ejecuta el que coincida.
	match property:
		# Asocia la clave "ALICE_BLUE" con  dentro del diccionario.
		"ALICE_BLUE":
			# Termina el metodo y devuelve Color.ALICE_BLUE a quien lo llamo.
			return Color.ALICE_BLUE
		# Asocia la clave "ANTIQUE_WHITE" con  dentro del diccionario.
		"ANTIQUE_WHITE":
			# Termina el metodo y devuelve Color.ANTIQUE_WHITE a quien lo llamo.
			return Color.ANTIQUE_WHITE
		# Asocia la clave "AQUA" con  dentro del diccionario.
		"AQUA":
			# Termina el metodo y devuelve Color.AQUA a quien lo llamo.
			return Color.AQUA
		# Asocia la clave "AQUAMARINE" con  dentro del diccionario.
		"AQUAMARINE":
			# Termina el metodo y devuelve Color.AQUAMARINE a quien lo llamo.
			return Color.AQUAMARINE
		# Asocia la clave "AZURE" con  dentro del diccionario.
		"AZURE":
			# Termina el metodo y devuelve Color.AZURE a quien lo llamo.
			return Color.AZURE
		# Asocia la clave "BEIGE" con  dentro del diccionario.
		"BEIGE":
			# Termina el metodo y devuelve Color.BEIGE a quien lo llamo.
			return Color.BEIGE
		# Asocia la clave "BISQUE" con  dentro del diccionario.
		"BISQUE":
			# Termina el metodo y devuelve Color.BISQUE a quien lo llamo.
			return Color.BISQUE
		# Asocia la clave "BLACK" con  dentro del diccionario.
		"BLACK":
			# Termina el metodo y devuelve Color.BLACK a quien lo llamo.
			return Color.BLACK
		# Asocia la clave "BLANCHED_ALMOND" con  dentro del diccionario.
		"BLANCHED_ALMOND":
			# Termina el metodo y devuelve Color.BLANCHED_ALMOND a quien lo llamo.
			return Color.BLANCHED_ALMOND
		# Asocia la clave "BLUE" con  dentro del diccionario.
		"BLUE":
			# Termina el metodo y devuelve Color.BLUE a quien lo llamo.
			return Color.BLUE
		# Asocia la clave "BLUE_VIOLET" con  dentro del diccionario.
		"BLUE_VIOLET":
			# Termina el metodo y devuelve Color.BLUE_VIOLET a quien lo llamo.
			return Color.BLUE_VIOLET
		# Asocia la clave "BROWN" con  dentro del diccionario.
		"BROWN":
			# Termina el metodo y devuelve Color.BROWN a quien lo llamo.
			return Color.BROWN
		# Asocia la clave "BURLYWOOD" con  dentro del diccionario.
		"BURLYWOOD":
			# Termina el metodo y devuelve Color.BURLYWOOD a quien lo llamo.
			return Color.BURLYWOOD
		# Asocia la clave "CADET_BLUE" con  dentro del diccionario.
		"CADET_BLUE":
			# Termina el metodo y devuelve Color.CADET_BLUE a quien lo llamo.
			return Color.CADET_BLUE
		# Asocia la clave "CHARTREUSE" con  dentro del diccionario.
		"CHARTREUSE":
			# Termina el metodo y devuelve Color.CHARTREUSE a quien lo llamo.
			return Color.CHARTREUSE
		# Asocia la clave "CHOCOLATE" con  dentro del diccionario.
		"CHOCOLATE":
			# Termina el metodo y devuelve Color.CHOCOLATE a quien lo llamo.
			return Color.CHOCOLATE
		# Asocia la clave "CORAL" con  dentro del diccionario.
		"CORAL":
			# Termina el metodo y devuelve Color.CORAL a quien lo llamo.
			return Color.CORAL
		# Asocia la clave "CORNFLOWER_BLUE" con  dentro del diccionario.
		"CORNFLOWER_BLUE":
			# Termina el metodo y devuelve Color.CORNFLOWER_BLUE a quien lo llamo.
			return Color.CORNFLOWER_BLUE
		# Asocia la clave "CORNSILK" con  dentro del diccionario.
		"CORNSILK":
			# Termina el metodo y devuelve Color.CORNSILK a quien lo llamo.
			return Color.CORNSILK
		# Asocia la clave "CRIMSON" con  dentro del diccionario.
		"CRIMSON":
			# Termina el metodo y devuelve Color.CRIMSON a quien lo llamo.
			return Color.CRIMSON
		# Asocia la clave "CYAN" con  dentro del diccionario.
		"CYAN":
			# Termina el metodo y devuelve Color.CYAN a quien lo llamo.
			return Color.CYAN
		# Asocia la clave "DARK_BLUE" con  dentro del diccionario.
		"DARK_BLUE":
			# Termina el metodo y devuelve Color.DARK_BLUE a quien lo llamo.
			return Color.DARK_BLUE
		# Asocia la clave "DARK_CYAN" con  dentro del diccionario.
		"DARK_CYAN":
			# Termina el metodo y devuelve Color.DARK_CYAN a quien lo llamo.
			return Color.DARK_CYAN
		# Asocia la clave "DARK_GOLDENROD" con  dentro del diccionario.
		"DARK_GOLDENROD":
			# Termina el metodo y devuelve Color.DARK_GOLDENROD a quien lo llamo.
			return Color.DARK_GOLDENROD
		# Asocia la clave "DARK_GRAY" con  dentro del diccionario.
		"DARK_GRAY":
			# Termina el metodo y devuelve Color.DARK_GRAY a quien lo llamo.
			return Color.DARK_GRAY
		# Asocia la clave "DARK_GREEN" con  dentro del diccionario.
		"DARK_GREEN":
			# Termina el metodo y devuelve Color.DARK_GREEN a quien lo llamo.
			return Color.DARK_GREEN
		# Asocia la clave "DARK_KHAKI" con  dentro del diccionario.
		"DARK_KHAKI":
			# Termina el metodo y devuelve Color.DARK_KHAKI a quien lo llamo.
			return Color.DARK_KHAKI
		# Asocia la clave "DARK_MAGENTA" con  dentro del diccionario.
		"DARK_MAGENTA":
			# Termina el metodo y devuelve Color.DARK_MAGENTA a quien lo llamo.
			return Color.DARK_MAGENTA
		# Asocia la clave "DARK_OLIVE_GREEN" con  dentro del diccionario.
		"DARK_OLIVE_GREEN":
			# Termina el metodo y devuelve Color.DARK_OLIVE_GREEN a quien lo llamo.
			return Color.DARK_OLIVE_GREEN
		# Asocia la clave "DARK_ORANGE" con  dentro del diccionario.
		"DARK_ORANGE":
			# Termina el metodo y devuelve Color.DARK_ORANGE a quien lo llamo.
			return Color.DARK_ORANGE
		# Asocia la clave "DARK_ORCHID" con  dentro del diccionario.
		"DARK_ORCHID":
			# Termina el metodo y devuelve Color.DARK_ORCHID a quien lo llamo.
			return Color.DARK_ORCHID
		# Asocia la clave "DARK_RED" con  dentro del diccionario.
		"DARK_RED":
			# Termina el metodo y devuelve Color.DARK_RED a quien lo llamo.
			return Color.DARK_RED
		# Asocia la clave "DARK_SALMON" con  dentro del diccionario.
		"DARK_SALMON":
			# Termina el metodo y devuelve Color.DARK_SALMON a quien lo llamo.
			return Color.DARK_SALMON
		# Asocia la clave "DARK_SEA_GREEN" con  dentro del diccionario.
		"DARK_SEA_GREEN":
			# Termina el metodo y devuelve Color.DARK_SEA_GREEN a quien lo llamo.
			return Color.DARK_SEA_GREEN
		# Asocia la clave "DARK_SLATE_BLUE" con  dentro del diccionario.
		"DARK_SLATE_BLUE":
			# Termina el metodo y devuelve Color.DARK_SLATE_BLUE a quien lo llamo.
			return Color.DARK_SLATE_BLUE
		# Asocia la clave "DARK_SLATE_GRAY" con  dentro del diccionario.
		"DARK_SLATE_GRAY":
			# Termina el metodo y devuelve Color.DARK_SLATE_GRAY a quien lo llamo.
			return Color.DARK_SLATE_GRAY
		# Asocia la clave "DARK_TURQUOISE" con  dentro del diccionario.
		"DARK_TURQUOISE":
			# Termina el metodo y devuelve Color.DARK_TURQUOISE a quien lo llamo.
			return Color.DARK_TURQUOISE
		# Asocia la clave "DARK_VIOLET" con  dentro del diccionario.
		"DARK_VIOLET":
			# Termina el metodo y devuelve Color.DARK_VIOLET a quien lo llamo.
			return Color.DARK_VIOLET
		# Asocia la clave "DEEP_PINK" con  dentro del diccionario.
		"DEEP_PINK":
			# Termina el metodo y devuelve Color.DEEP_PINK a quien lo llamo.
			return Color.DEEP_PINK
		# Asocia la clave "DEEP_SKY_BLUE" con  dentro del diccionario.
		"DEEP_SKY_BLUE":
			# Termina el metodo y devuelve Color.DEEP_SKY_BLUE a quien lo llamo.
			return Color.DEEP_SKY_BLUE
		# Asocia la clave "DIM_GRAY" con  dentro del diccionario.
		"DIM_GRAY":
			# Termina el metodo y devuelve Color.DIM_GRAY a quien lo llamo.
			return Color.DIM_GRAY
		# Asocia la clave "DODGER_BLUE" con  dentro del diccionario.
		"DODGER_BLUE":
			# Termina el metodo y devuelve Color.DODGER_BLUE a quien lo llamo.
			return Color.DODGER_BLUE
		# Asocia la clave "FIREBRICK" con  dentro del diccionario.
		"FIREBRICK":
			# Termina el metodo y devuelve Color.FIREBRICK a quien lo llamo.
			return Color.FIREBRICK
		# Asocia la clave "FLORAL_WHITE" con  dentro del diccionario.
		"FLORAL_WHITE":
			# Termina el metodo y devuelve Color.FLORAL_WHITE a quien lo llamo.
			return Color.FLORAL_WHITE
		# Asocia la clave "FOREST_GREEN" con  dentro del diccionario.
		"FOREST_GREEN":
			# Termina el metodo y devuelve Color.FOREST_GREEN a quien lo llamo.
			return Color.FOREST_GREEN
		# Asocia la clave "FUCHSIA" con  dentro del diccionario.
		"FUCHSIA":
			# Termina el metodo y devuelve Color.FUCHSIA a quien lo llamo.
			return Color.FUCHSIA
		# Asocia la clave "GAINSBORO" con  dentro del diccionario.
		"GAINSBORO":
			# Termina el metodo y devuelve Color.GAINSBORO a quien lo llamo.
			return Color.GAINSBORO
		# Asocia la clave "GHOST_WHITE" con  dentro del diccionario.
		"GHOST_WHITE":
			# Termina el metodo y devuelve Color.GHOST_WHITE a quien lo llamo.
			return Color.GHOST_WHITE
		# Asocia la clave "GOLD" con  dentro del diccionario.
		"GOLD":
			# Termina el metodo y devuelve Color.GOLD a quien lo llamo.
			return Color.GOLD
		# Asocia la clave "GOLDENROD" con  dentro del diccionario.
		"GOLDENROD":
			# Termina el metodo y devuelve Color.GOLDENROD a quien lo llamo.
			return Color.GOLDENROD
		# Asocia la clave "GRAY" con  dentro del diccionario.
		"GRAY":
			# Termina el metodo y devuelve Color.GRAY a quien lo llamo.
			return Color.GRAY
		# Asocia la clave "GREEN" con  dentro del diccionario.
		"GREEN":
			# Termina el metodo y devuelve Color.GREEN a quien lo llamo.
			return Color.GREEN
		# Asocia la clave "GREEN_YELLOW" con  dentro del diccionario.
		"GREEN_YELLOW":
			# Termina el metodo y devuelve Color.GREEN_YELLOW a quien lo llamo.
			return Color.GREEN_YELLOW
		# Asocia la clave "HONEYDEW" con  dentro del diccionario.
		"HONEYDEW":
			# Termina el metodo y devuelve Color.HONEYDEW a quien lo llamo.
			return Color.HONEYDEW
		# Asocia la clave "HOT_PINK" con  dentro del diccionario.
		"HOT_PINK":
			# Termina el metodo y devuelve Color.HOT_PINK a quien lo llamo.
			return Color.HOT_PINK
		# Asocia la clave "INDIAN_RED" con  dentro del diccionario.
		"INDIAN_RED":
			# Termina el metodo y devuelve Color.INDIAN_RED a quien lo llamo.
			return Color.INDIAN_RED
		# Asocia la clave "INDIGO" con  dentro del diccionario.
		"INDIGO":
			# Termina el metodo y devuelve Color.INDIGO a quien lo llamo.
			return Color.INDIGO
		# Asocia la clave "IVORY" con  dentro del diccionario.
		"IVORY":
			# Termina el metodo y devuelve Color.IVORY a quien lo llamo.
			return Color.IVORY
		# Asocia la clave "KHAKI" con  dentro del diccionario.
		"KHAKI":
			# Termina el metodo y devuelve Color.KHAKI a quien lo llamo.
			return Color.KHAKI
		# Asocia la clave "LAVENDER" con  dentro del diccionario.
		"LAVENDER":
			# Termina el metodo y devuelve Color.LAVENDER a quien lo llamo.
			return Color.LAVENDER
		# Asocia la clave "LAVENDER_BLUSH" con  dentro del diccionario.
		"LAVENDER_BLUSH":
			# Termina el metodo y devuelve Color.LAVENDER_BLUSH a quien lo llamo.
			return Color.LAVENDER_BLUSH
		# Asocia la clave "LAWN_GREEN" con  dentro del diccionario.
		"LAWN_GREEN":
			# Termina el metodo y devuelve Color.LAWN_GREEN a quien lo llamo.
			return Color.LAWN_GREEN
		# Asocia la clave "LEMON_CHIFFON" con  dentro del diccionario.
		"LEMON_CHIFFON":
			# Termina el metodo y devuelve Color.LEMON_CHIFFON a quien lo llamo.
			return Color.LEMON_CHIFFON
		# Asocia la clave "LIGHT_BLUE" con  dentro del diccionario.
		"LIGHT_BLUE":
			# Termina el metodo y devuelve Color.LIGHT_BLUE a quien lo llamo.
			return Color.LIGHT_BLUE
		# Asocia la clave "LIGHT_CORAL" con  dentro del diccionario.
		"LIGHT_CORAL":
			# Termina el metodo y devuelve Color.LIGHT_CORAL a quien lo llamo.
			return Color.LIGHT_CORAL
		# Asocia la clave "LIGHT_CYAN" con  dentro del diccionario.
		"LIGHT_CYAN":
			# Termina el metodo y devuelve Color.LIGHT_CYAN a quien lo llamo.
			return Color.LIGHT_CYAN
		# Asocia la clave "LIGHT_GOLDENROD" con  dentro del diccionario.
		"LIGHT_GOLDENROD":
			# Termina el metodo y devuelve Color.LIGHT_GOLDENROD a quien lo llamo.
			return Color.LIGHT_GOLDENROD
		# Asocia la clave "LIGHT_GRAY" con  dentro del diccionario.
		"LIGHT_GRAY":
			# Termina el metodo y devuelve Color.LIGHT_GRAY a quien lo llamo.
			return Color.LIGHT_GRAY
		# Asocia la clave "LIGHT_GREEN" con  dentro del diccionario.
		"LIGHT_GREEN":
			# Termina el metodo y devuelve Color.LIGHT_GREEN a quien lo llamo.
			return Color.LIGHT_GREEN
		# Asocia la clave "LIGHT_PINK" con  dentro del diccionario.
		"LIGHT_PINK":
			# Termina el metodo y devuelve Color.LIGHT_PINK a quien lo llamo.
			return Color.LIGHT_PINK
		# Asocia la clave "LIGHT_SALMON" con  dentro del diccionario.
		"LIGHT_SALMON":
			# Termina el metodo y devuelve Color.LIGHT_SALMON a quien lo llamo.
			return Color.LIGHT_SALMON
		# Asocia la clave "LIGHT_SEA_GREEN" con  dentro del diccionario.
		"LIGHT_SEA_GREEN":
			# Termina el metodo y devuelve Color.LIGHT_SEA_GREEN a quien lo llamo.
			return Color.LIGHT_SEA_GREEN
		# Asocia la clave "LIGHT_SKY_BLUE" con  dentro del diccionario.
		"LIGHT_SKY_BLUE":
			# Termina el metodo y devuelve Color.LIGHT_SKY_BLUE a quien lo llamo.
			return Color.LIGHT_SKY_BLUE
		# Asocia la clave "LIGHT_SLATE_GRAY" con  dentro del diccionario.
		"LIGHT_SLATE_GRAY":
			# Termina el metodo y devuelve Color.LIGHT_SLATE_GRAY a quien lo llamo.
			return Color.LIGHT_SLATE_GRAY
		# Asocia la clave "LIGHT_STEEL_BLUE" con  dentro del diccionario.
		"LIGHT_STEEL_BLUE":
			# Termina el metodo y devuelve Color.LIGHT_STEEL_BLUE a quien lo llamo.
			return Color.LIGHT_STEEL_BLUE
		# Asocia la clave "LIGHT_YELLOW" con  dentro del diccionario.
		"LIGHT_YELLOW":
			# Termina el metodo y devuelve Color.LIGHT_YELLOW a quien lo llamo.
			return Color.LIGHT_YELLOW
		# Asocia la clave "LIME" con  dentro del diccionario.
		"LIME":
			# Termina el metodo y devuelve Color.LIME a quien lo llamo.
			return Color.LIME
		# Asocia la clave "LIME_GREEN" con  dentro del diccionario.
		"LIME_GREEN":
			# Termina el metodo y devuelve Color.LIME_GREEN a quien lo llamo.
			return Color.LIME_GREEN
		# Asocia la clave "LINEN" con  dentro del diccionario.
		"LINEN":
			# Termina el metodo y devuelve Color.LINEN a quien lo llamo.
			return Color.LINEN
		# Asocia la clave "MAGENTA" con  dentro del diccionario.
		"MAGENTA":
			# Termina el metodo y devuelve Color.MAGENTA a quien lo llamo.
			return Color.MAGENTA
		# Asocia la clave "MAROON" con  dentro del diccionario.
		"MAROON":
			# Termina el metodo y devuelve Color.MAROON a quien lo llamo.
			return Color.MAROON
		# Asocia la clave "MEDIUM_AQUAMARINE" con  dentro del diccionario.
		"MEDIUM_AQUAMARINE":
			# Termina el metodo y devuelve Color.MEDIUM_AQUAMARINE a quien lo llamo.
			return Color.MEDIUM_AQUAMARINE
		# Asocia la clave "MEDIUM_BLUE" con  dentro del diccionario.
		"MEDIUM_BLUE":
			# Termina el metodo y devuelve Color.MEDIUM_BLUE a quien lo llamo.
			return Color.MEDIUM_BLUE
		# Asocia la clave "MEDIUM_ORCHID" con  dentro del diccionario.
		"MEDIUM_ORCHID":
			# Termina el metodo y devuelve Color.MEDIUM_ORCHID a quien lo llamo.
			return Color.MEDIUM_ORCHID
		# Asocia la clave "MEDIUM_PURPLE" con  dentro del diccionario.
		"MEDIUM_PURPLE":
			# Termina el metodo y devuelve Color.MEDIUM_PURPLE a quien lo llamo.
			return Color.MEDIUM_PURPLE
		# Asocia la clave "MEDIUM_SEA_GREEN" con  dentro del diccionario.
		"MEDIUM_SEA_GREEN":
			# Termina el metodo y devuelve Color.MEDIUM_SEA_GREEN a quien lo llamo.
			return Color.MEDIUM_SEA_GREEN
		# Asocia la clave "MEDIUM_SLATE_BLUE" con  dentro del diccionario.
		"MEDIUM_SLATE_BLUE":
			# Termina el metodo y devuelve Color.MEDIUM_SLATE_BLUE a quien lo llamo.
			return Color.MEDIUM_SLATE_BLUE
		# Asocia la clave "MEDIUM_SPRING_GREEN" con  dentro del diccionario.
		"MEDIUM_SPRING_GREEN":
			# Termina el metodo y devuelve Color.MEDIUM_SPRING_GREEN a quien lo llamo.
			return Color.MEDIUM_SPRING_GREEN
		# Asocia la clave "MEDIUM_TURQUOISE" con  dentro del diccionario.
		"MEDIUM_TURQUOISE":
			# Termina el metodo y devuelve Color.MEDIUM_TURQUOISE a quien lo llamo.
			return Color.MEDIUM_TURQUOISE
		# Asocia la clave "MEDIUM_VIOLET_RED" con  dentro del diccionario.
		"MEDIUM_VIOLET_RED":
			# Termina el metodo y devuelve Color.MEDIUM_VIOLET_RED a quien lo llamo.
			return Color.MEDIUM_VIOLET_RED
		# Asocia la clave "MIDNIGHT_BLUE" con  dentro del diccionario.
		"MIDNIGHT_BLUE":
			# Termina el metodo y devuelve Color.MIDNIGHT_BLUE a quien lo llamo.
			return Color.MIDNIGHT_BLUE
		# Asocia la clave "MINT_CREAM" con  dentro del diccionario.
		"MINT_CREAM":
			# Termina el metodo y devuelve Color.MINT_CREAM a quien lo llamo.
			return Color.MINT_CREAM
		# Asocia la clave "MISTY_ROSE" con  dentro del diccionario.
		"MISTY_ROSE":
			# Termina el metodo y devuelve Color.MISTY_ROSE a quien lo llamo.
			return Color.MISTY_ROSE
		# Asocia la clave "MOCCASIN" con  dentro del diccionario.
		"MOCCASIN":
			# Termina el metodo y devuelve Color.MOCCASIN a quien lo llamo.
			return Color.MOCCASIN
		# Asocia la clave "NAVAJO_WHITE" con  dentro del diccionario.
		"NAVAJO_WHITE":
			# Termina el metodo y devuelve Color.NAVAJO_WHITE a quien lo llamo.
			return Color.NAVAJO_WHITE
		# Asocia la clave "NAVY_BLUE" con  dentro del diccionario.
		"NAVY_BLUE":
			# Termina el metodo y devuelve Color.NAVY_BLUE a quien lo llamo.
			return Color.NAVY_BLUE
		# Asocia la clave "OLD_LACE" con  dentro del diccionario.
		"OLD_LACE":
			# Termina el metodo y devuelve Color.OLD_LACE a quien lo llamo.
			return Color.OLD_LACE
		# Asocia la clave "OLIVE" con  dentro del diccionario.
		"OLIVE":
			# Termina el metodo y devuelve Color.OLIVE a quien lo llamo.
			return Color.OLIVE
		# Asocia la clave "OLIVE_DRAB" con  dentro del diccionario.
		"OLIVE_DRAB":
			# Termina el metodo y devuelve Color.OLIVE_DRAB a quien lo llamo.
			return Color.OLIVE_DRAB
		# Asocia la clave "ORANGE" con  dentro del diccionario.
		"ORANGE":
			# Termina el metodo y devuelve Color.ORANGE a quien lo llamo.
			return Color.ORANGE
		# Asocia la clave "ORANGE_RED" con  dentro del diccionario.
		"ORANGE_RED":
			# Termina el metodo y devuelve Color.ORANGE_RED a quien lo llamo.
			return Color.ORANGE_RED
		# Asocia la clave "ORCHID" con  dentro del diccionario.
		"ORCHID":
			# Termina el metodo y devuelve Color.ORCHID a quien lo llamo.
			return Color.ORCHID
		# Asocia la clave "PALE_GOLDENROD" con  dentro del diccionario.
		"PALE_GOLDENROD":
			# Termina el metodo y devuelve Color.PALE_GOLDENROD a quien lo llamo.
			return Color.PALE_GOLDENROD
		# Asocia la clave "PALE_GREEN" con  dentro del diccionario.
		"PALE_GREEN":
			# Termina el metodo y devuelve Color.PALE_GREEN a quien lo llamo.
			return Color.PALE_GREEN
		# Asocia la clave "PALE_TURQUOISE" con  dentro del diccionario.
		"PALE_TURQUOISE":
			# Termina el metodo y devuelve Color.PALE_TURQUOISE a quien lo llamo.
			return Color.PALE_TURQUOISE
		# Asocia la clave "PALE_VIOLET_RED" con  dentro del diccionario.
		"PALE_VIOLET_RED":
			# Termina el metodo y devuelve Color.PALE_VIOLET_RED a quien lo llamo.
			return Color.PALE_VIOLET_RED
		# Asocia la clave "PAPAYA_WHIP" con  dentro del diccionario.
		"PAPAYA_WHIP":
			# Termina el metodo y devuelve Color.PAPAYA_WHIP a quien lo llamo.
			return Color.PAPAYA_WHIP
		# Asocia la clave "PEACH_PUFF" con  dentro del diccionario.
		"PEACH_PUFF":
			# Termina el metodo y devuelve Color.PEACH_PUFF a quien lo llamo.
			return Color.PEACH_PUFF
		# Asocia la clave "PERU" con  dentro del diccionario.
		"PERU":
			# Termina el metodo y devuelve Color.PERU a quien lo llamo.
			return Color.PERU
		# Asocia la clave "PINK" con  dentro del diccionario.
		"PINK":
			# Termina el metodo y devuelve Color.PINK a quien lo llamo.
			return Color.PINK
		# Asocia la clave "PLUM" con  dentro del diccionario.
		"PLUM":
			# Termina el metodo y devuelve Color.PLUM a quien lo llamo.
			return Color.PLUM
		# Asocia la clave "POWDER_BLUE" con  dentro del diccionario.
		"POWDER_BLUE":
			# Termina el metodo y devuelve Color.POWDER_BLUE a quien lo llamo.
			return Color.POWDER_BLUE
		# Asocia la clave "PURPLE" con  dentro del diccionario.
		"PURPLE":
			# Termina el metodo y devuelve Color.PURPLE a quien lo llamo.
			return Color.PURPLE
		# Asocia la clave "REBECCA_PURPLE" con  dentro del diccionario.
		"REBECCA_PURPLE":
			# Termina el metodo y devuelve Color.REBECCA_PURPLE a quien lo llamo.
			return Color.REBECCA_PURPLE
		# Asocia la clave "RED" con  dentro del diccionario.
		"RED":
			# Termina el metodo y devuelve Color.RED a quien lo llamo.
			return Color.RED
		# Asocia la clave "ROSY_BROWN" con  dentro del diccionario.
		"ROSY_BROWN":
			# Termina el metodo y devuelve Color.ROSY_BROWN a quien lo llamo.
			return Color.ROSY_BROWN
		# Asocia la clave "ROYAL_BLUE" con  dentro del diccionario.
		"ROYAL_BLUE":
			# Termina el metodo y devuelve Color.ROYAL_BLUE a quien lo llamo.
			return Color.ROYAL_BLUE
		# Asocia la clave "SADDLE_BROWN" con  dentro del diccionario.
		"SADDLE_BROWN":
			# Termina el metodo y devuelve Color.SADDLE_BROWN a quien lo llamo.
			return Color.SADDLE_BROWN
		# Asocia la clave "SALMON" con  dentro del diccionario.
		"SALMON":
			# Termina el metodo y devuelve Color.SALMON a quien lo llamo.
			return Color.SALMON
		# Asocia la clave "SANDY_BROWN" con  dentro del diccionario.
		"SANDY_BROWN":
			# Termina el metodo y devuelve Color.SANDY_BROWN a quien lo llamo.
			return Color.SANDY_BROWN
		# Asocia la clave "SEA_GREEN" con  dentro del diccionario.
		"SEA_GREEN":
			# Termina el metodo y devuelve Color.SEA_GREEN a quien lo llamo.
			return Color.SEA_GREEN
		# Asocia la clave "SEASHELL" con  dentro del diccionario.
		"SEASHELL":
			# Termina el metodo y devuelve Color.SEASHELL a quien lo llamo.
			return Color.SEASHELL
		# Asocia la clave "SIENNA" con  dentro del diccionario.
		"SIENNA":
			# Termina el metodo y devuelve Color.SIENNA a quien lo llamo.
			return Color.SIENNA
		# Asocia la clave "SILVER" con  dentro del diccionario.
		"SILVER":
			# Termina el metodo y devuelve Color.SILVER a quien lo llamo.
			return Color.SILVER
		# Asocia la clave "SKY_BLUE" con  dentro del diccionario.
		"SKY_BLUE":
			# Termina el metodo y devuelve Color.SKY_BLUE a quien lo llamo.
			return Color.SKY_BLUE
		# Asocia la clave "SLATE_BLUE" con  dentro del diccionario.
		"SLATE_BLUE":
			# Termina el metodo y devuelve Color.SLATE_BLUE a quien lo llamo.
			return Color.SLATE_BLUE
		# Asocia la clave "SLATE_GRAY" con  dentro del diccionario.
		"SLATE_GRAY":
			# Termina el metodo y devuelve Color.SLATE_GRAY a quien lo llamo.
			return Color.SLATE_GRAY
		# Asocia la clave "SNOW" con  dentro del diccionario.
		"SNOW":
			# Termina el metodo y devuelve Color.SNOW a quien lo llamo.
			return Color.SNOW
		# Asocia la clave "SPRING_GREEN" con  dentro del diccionario.
		"SPRING_GREEN":
			# Termina el metodo y devuelve Color.SPRING_GREEN a quien lo llamo.
			return Color.SPRING_GREEN
		# Asocia la clave "STEEL_BLUE" con  dentro del diccionario.
		"STEEL_BLUE":
			# Termina el metodo y devuelve Color.STEEL_BLUE a quien lo llamo.
			return Color.STEEL_BLUE
		# Asocia la clave "TAN" con  dentro del diccionario.
		"TAN":
			# Termina el metodo y devuelve Color.TAN a quien lo llamo.
			return Color.TAN
		# Asocia la clave "TEAL" con  dentro del diccionario.
		"TEAL":
			# Termina el metodo y devuelve Color.TEAL a quien lo llamo.
			return Color.TEAL
		# Asocia la clave "THISTLE" con  dentro del diccionario.
		"THISTLE":
			# Termina el metodo y devuelve Color.THISTLE a quien lo llamo.
			return Color.THISTLE
		# Asocia la clave "TOMATO" con  dentro del diccionario.
		"TOMATO":
			# Termina el metodo y devuelve Color.TOMATO a quien lo llamo.
			return Color.TOMATO
		# Asocia la clave "TRANSPARENT" con  dentro del diccionario.
		"TRANSPARENT":
			# Termina el metodo y devuelve Color.TRANSPARENT a quien lo llamo.
			return Color.TRANSPARENT
		# Asocia la clave "TURQUOISE" con  dentro del diccionario.
		"TURQUOISE":
			# Termina el metodo y devuelve Color.TURQUOISE a quien lo llamo.
			return Color.TURQUOISE
		# Asocia la clave "VIOLET" con  dentro del diccionario.
		"VIOLET":
			# Termina el metodo y devuelve Color.VIOLET a quien lo llamo.
			return Color.VIOLET
		# Asocia la clave "WEB_GRAY" con  dentro del diccionario.
		"WEB_GRAY":
			# Termina el metodo y devuelve Color.WEB_GRAY a quien lo llamo.
			return Color.WEB_GRAY
		# Asocia la clave "WEB_GREEN" con  dentro del diccionario.
		"WEB_GREEN":
			# Termina el metodo y devuelve Color.WEB_GREEN a quien lo llamo.
			return Color.WEB_GREEN
		# Asocia la clave "WEB_MAROON" con  dentro del diccionario.
		"WEB_MAROON":
			# Termina el metodo y devuelve Color.WEB_MAROON a quien lo llamo.
			return Color.WEB_MAROON
		# Asocia la clave "WEB_PURPLE" con  dentro del diccionario.
		"WEB_PURPLE":
			# Termina el metodo y devuelve Color.WEB_PURPLE a quien lo llamo.
			return Color.WEB_PURPLE
		# Asocia la clave "WHEAT" con  dentro del diccionario.
		"WHEAT":
			# Termina el metodo y devuelve Color.WHEAT a quien lo llamo.
			return Color.WHEAT
		# Asocia la clave "WHITE" con  dentro del diccionario.
		"WHITE":
			# Termina el metodo y devuelve Color.WHITE a quien lo llamo.
			return Color.WHITE
		# Asocia la clave "WHITE_SMOKE" con  dentro del diccionario.
		"WHITE_SMOKE":
			# Termina el metodo y devuelve Color.WHITE_SMOKE a quien lo llamo.
			return Color.WHITE_SMOKE
		# Asocia la clave "YELLOW" con  dentro del diccionario.
		"YELLOW":
			# Termina el metodo y devuelve Color.YELLOW a quien lo llamo.
			return Color.YELLOW
		# Asocia la clave "YELLOW_GREEN" con  dentro del diccionario.
		"YELLOW_GREEN":
			# Termina el metodo y devuelve Color.YELLOW_GREEN a quien lo llamo.
			return Color.YELLOW_GREEN

	# Termina el metodo y devuelve color[property] a quien lo llamo.
	return color[property]


# Ejecuta esta instruccion: static func resolve_vector2_property(vector: Vector2, property: String):.
static func resolve_vector2_property(vector: Vector2, property: String):
	# Compara property con los casos siguientes y ejecuta el que coincida.
	match property:
		# Asocia la clave "AXIS_X" con  dentro del diccionario.
		"AXIS_X":
			# Termina el metodo y devuelve Vector2.AXIS_X a quien lo llamo.
			return Vector2.AXIS_X
		# Asocia la clave "AXIS_Y" con  dentro del diccionario.
		"AXIS_Y":
			# Termina el metodo y devuelve Vector2.AXIS_Y a quien lo llamo.
			return Vector2.AXIS_Y
		# Asocia la clave "ZERO" con  dentro del diccionario.
		"ZERO":
			# Termina el metodo y devuelve Vector2.ZERO a quien lo llamo.
			return Vector2.ZERO
		# Asocia la clave "ONE" con  dentro del diccionario.
		"ONE":
			# Termina el metodo y devuelve Vector2.ONE a quien lo llamo.
			return Vector2.ONE
		# Asocia la clave "INF" con  dentro del diccionario.
		"INF":
			# Termina el metodo y devuelve Vector2.INF a quien lo llamo.
			return Vector2.INF
		# Asocia la clave "LEFT" con  dentro del diccionario.
		"LEFT":
			# Termina el metodo y devuelve Vector2.LEFT a quien lo llamo.
			return Vector2.LEFT
		# Asocia la clave "RIGHT" con  dentro del diccionario.
		"RIGHT":
			# Termina el metodo y devuelve Vector2.RIGHT a quien lo llamo.
			return Vector2.RIGHT
		# Asocia la clave "UP" con  dentro del diccionario.
		"UP":
			# Termina el metodo y devuelve Vector2.UP a quien lo llamo.
			return Vector2.UP
		# Asocia la clave "DOWN" con  dentro del diccionario.
		"DOWN":
			# Termina el metodo y devuelve Vector2.DOWN a quien lo llamo.
			return Vector2.DOWN

		# Asocia la clave "DOWN_LEFT" con  dentro del diccionario.
		"DOWN_LEFT":
			# Termina el metodo y devuelve Vector2(-1, 1) a quien lo llamo.
			return Vector2(-1, 1)
		# Asocia la clave "DOWN_RIGHT" con  dentro del diccionario.
		"DOWN_RIGHT":
			# Termina el metodo y devuelve Vector2(1, 1) a quien lo llamo.
			return Vector2(1, 1)
		# Asocia la clave "UP_LEFT" con  dentro del diccionario.
		"UP_LEFT":
			# Termina el metodo y devuelve Vector2(-1, -1) a quien lo llamo.
			return Vector2(-1, -1)
		# Asocia la clave "UP_RIGHT" con  dentro del diccionario.
		"UP_RIGHT":
			# Termina el metodo y devuelve Vector2(1, -1) a quien lo llamo.
			return Vector2(1, -1)

	# Termina el metodo y devuelve vector[property] a quien lo llamo.
	return vector[property]


# Ejecuta esta instruccion: static func resolve_vector3_property(vector: Vector3, property: String):.
static func resolve_vector3_property(vector: Vector3, property: String):
	# Compara property con los casos siguientes y ejecuta el que coincida.
	match property:
		# Asocia la clave "AXIS_X" con  dentro del diccionario.
		"AXIS_X":
			# Termina el metodo y devuelve Vector3.AXIS_X a quien lo llamo.
			return Vector3.AXIS_X
		# Asocia la clave "AXIS_Y" con  dentro del diccionario.
		"AXIS_Y":
			# Termina el metodo y devuelve Vector3.AXIS_Y a quien lo llamo.
			return Vector3.AXIS_Y
		# Asocia la clave "AXIS_Z" con  dentro del diccionario.
		"AXIS_Z":
			# Termina el metodo y devuelve Vector3.AXIS_Z a quien lo llamo.
			return Vector3.AXIS_Z
		# Asocia la clave "ZERO" con  dentro del diccionario.
		"ZERO":
			# Termina el metodo y devuelve Vector3.ZERO a quien lo llamo.
			return Vector3.ZERO
		# Asocia la clave "ONE" con  dentro del diccionario.
		"ONE":
			# Termina el metodo y devuelve Vector3.ONE a quien lo llamo.
			return Vector3.ONE
		# Asocia la clave "INF" con  dentro del diccionario.
		"INF":
			# Termina el metodo y devuelve Vector3.INF a quien lo llamo.
			return Vector3.INF
		# Asocia la clave "LEFT" con  dentro del diccionario.
		"LEFT":
			# Termina el metodo y devuelve Vector3.LEFT a quien lo llamo.
			return Vector3.LEFT
		# Asocia la clave "RIGHT" con  dentro del diccionario.
		"RIGHT":
			# Termina el metodo y devuelve Vector3.RIGHT a quien lo llamo.
			return Vector3.RIGHT
		# Asocia la clave "UP" con  dentro del diccionario.
		"UP":
			# Termina el metodo y devuelve Vector3.UP a quien lo llamo.
			return Vector3.UP
		# Asocia la clave "DOWN" con  dentro del diccionario.
		"DOWN":
			# Termina el metodo y devuelve Vector3.DOWN a quien lo llamo.
			return Vector3.DOWN
		# Asocia la clave "FORWARD" con  dentro del diccionario.
		"FORWARD":
			# Termina el metodo y devuelve Vector3.FORWARD a quien lo llamo.
			return Vector3.FORWARD
		# Asocia la clave "BACK" con  dentro del diccionario.
		"BACK":
			# Termina el metodo y devuelve Vector3.BACK a quien lo llamo.
			return Vector3.BACK
		# Asocia la clave "MODEL_LEFT" con  dentro del diccionario.
		"MODEL_LEFT":
			# Termina el metodo y devuelve Vector3(1, 0, 0) a quien lo llamo.
			return Vector3(1, 0, 0)
		# Asocia la clave "MODEL_RIGHT" con  dentro del diccionario.
		"MODEL_RIGHT":
			# Termina el metodo y devuelve Vector3(-1, 0, 0) a quien lo llamo.
			return Vector3(-1, 0, 0)
		# Asocia la clave "MODEL_TOP" con  dentro del diccionario.
		"MODEL_TOP":
			# Termina el metodo y devuelve Vector3(0, 1, 0) a quien lo llamo.
			return Vector3(0, 1, 0)
		# Asocia la clave "MODEL_BOTTOM" con  dentro del diccionario.
		"MODEL_BOTTOM":
			# Termina el metodo y devuelve Vector3(0, -1, 0) a quien lo llamo.
			return Vector3(0, -1, 0)
		# Asocia la clave "MODEL_FRONT" con  dentro del diccionario.
		"MODEL_FRONT":
			# Termina el metodo y devuelve Vector3(0, 0, 1) a quien lo llamo.
			return Vector3(0, 0, 1)
		# Asocia la clave "MODEL_REAR" con  dentro del diccionario.
		"MODEL_REAR":
			# Termina el metodo y devuelve Vector3(0, 0, -1) a quien lo llamo.
			return Vector3(0, 0, -1)

	# Termina el metodo y devuelve vector[property] a quien lo llamo.
	return vector[property]


# Ejecuta esta instruccion: static func resolve_vector4_property(vector: Vector4, property: String):.
static func resolve_vector4_property(vector: Vector4, property: String):
	# Compara property con los casos siguientes y ejecuta el que coincida.
	match property:
		# Asocia la clave "AXIS_X" con  dentro del diccionario.
		"AXIS_X":
			# Termina el metodo y devuelve Vector4.AXIS_X a quien lo llamo.
			return Vector4.AXIS_X
		# Asocia la clave "AXIS_Y" con  dentro del diccionario.
		"AXIS_Y":
			# Termina el metodo y devuelve Vector4.AXIS_Y a quien lo llamo.
			return Vector4.AXIS_Y
		# Asocia la clave "AXIS_Z" con  dentro del diccionario.
		"AXIS_Z":
			# Termina el metodo y devuelve Vector4.AXIS_Z a quien lo llamo.
			return Vector4.AXIS_Z
		# Asocia la clave "AXIS_W" con  dentro del diccionario.
		"AXIS_W":
			# Termina el metodo y devuelve Vector4.AXIS_W a quien lo llamo.
			return Vector4.AXIS_W
		# Asocia la clave "ZERO" con  dentro del diccionario.
		"ZERO":
			# Termina el metodo y devuelve Vector4.ZERO a quien lo llamo.
			return Vector4.ZERO
		# Asocia la clave "ONE" con  dentro del diccionario.
		"ONE":
			# Termina el metodo y devuelve Vector4.ONE a quien lo llamo.
			return Vector4.ONE
		# Asocia la clave "INF" con  dentro del diccionario.
		"INF":
			# Termina el metodo y devuelve Vector4.INF a quien lo llamo.
			return Vector4.INF

	# Termina el metodo y devuelve vector[property] a quien lo llamo.
	return vector[property]
