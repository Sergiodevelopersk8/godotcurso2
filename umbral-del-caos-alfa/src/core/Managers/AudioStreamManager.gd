#res://src/core/Managers/AudioStreamManager.gd
extends Node

# Crea num_players e inicializa su valor con 10.
var num_players = 10
# Crea bus e inicializa su valor con "SFX".
var bus = "SFX"

# Crea available e inicializa su valor con [].
var available = [] # audio nodos
# Crea queue e inicializa su valor con [].
var queue = []

#----------FUNCIONES DE SISTEMA-----------


# Inicializa referencias, conexiones y estado inicial del nodo al arrancar.
func _ready():
	# Guarda en process_mode el resultado de Node.PROCESS_MODE_ALWAYS.
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Recorre num_players y asigna cada elemento a i en cada vuelta.
	for i in num_players:
		# Crea p e inicializa su valor con AudioStreamPlayer.new().
		var p = AudioStreamPlayer.new()
		# Llama al metodo add_child para realizar esta accion en este punto.
		add_child(p)
		# Llama al metodo available.append para realizar esta accion en este punto.
		available.append(p)
		
		# Llama al metodo p.finished.connect para realizar esta accion en este punto.
		p.finished.connect(_on_stream_finished.bind(p))
		
		# Guarda en p.bus el resultado de bus.
		p.bus = bus
		


# Actualiza la l?gica del frame actual.
func _process(_delta: float) -> void:
	# Comprueba not queue.is_empty() and not available.is_empty(); ejecuta el bloque indentado solo cuando la condicion sea verdadera.
	if not queue.is_empty() and not available.is_empty():
		# Ejecuta esta instruccion: available[0].stream = load(queue.pop_front()).
		available[0].stream = load(queue.pop_front())
		# Ejecuta esta instruccion: available[0].play().
		available[0].play()
		# Llama al metodo available.pop_front para realizar esta accion en este punto.
		available.pop_front()


#----------FUNCIONES PROPIAS-----------

# Recupera un nodo de audio una vez que termina de reproducir su clip.
func _on_stream_finished(stream):
	# Llama al metodo available.append para realizar esta accion en este punto.
	available.append(stream)


# A?ade un clip de audio a la cola para reproducirlo con el gestor de sonido.
func play(sound_path:String):
	# Llama al metodo queue.append para realizar esta accion en este punto.
	queue.append(sound_path)
