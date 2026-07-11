extends Interact
class_name NPCBase

# 1. Definimos los estados posibles del ciclo de vida del cliente
enum ClienteState { PIDIENDO, ESPERANDO, ATENDIDO, ENOJADO }
var estado_actual: ClienteState = ClienteState.PIDIENDO

@onready var patience_timer: Timer = $PatienceTimer
@onready var order_label: Label3D = $OrderLabel


@export var tiempo_espera : float = 45.0
@export var pedido_actual : String = "Memela Base"

func _ready() -> void:
	can_be_loaded = false 
	id = "Hablar"
	# Conectamos la señal del temporizador por código por seguridad
	if patience_timer:
		patience_timer.timeout.connect(_on_patience_timer_timeout)

# 2. La función que ejecutará el Player al presionar la E en el cliente
func action_use() -> void:
	super.action_use()
	
	# Si apenas nos va a pedir, activamos el flujo
	if estado_actual == ClienteState.PIDIENDO:
		cambiar_estado(ClienteState.PIDIENDO)

# 3. El motor de estados: Controla qué pasa en cada fase
func cambiar_estado(nuevo_estado: ClienteState) -> void:
	estado_actual = nuevo_estado
	
	match estado_actual:
		ClienteState.PIDIENDO:
			if order_label:
				order_label.text = "Hola... Quiero una: " + pedido_actual
			print("El NPC ha hecho su pedido.")
			# Pasamos inmediatamente a que espere su comida
			cambiar_estado(ClienteState.ESPERANDO)
			
		ClienteState.ESPERANDO:
			if patience_timer:
				patience_timer.start(tiempo_espera)
			print("El cliente está esperando... Tic tac...")
			
		ClienteState.ATENDIDO:
			if patience_timer: patience_timer.stop()
			if order_label: order_label.text = "¡Gracias! * ruidos extraños *"
			print("Cliente feliz. Se va.")
			
		ClienteState.ENOJADO:
			if order_label: order_label.text = "TE TARDASTE... 💀"
			print("Se acabó el tiempo. ¡Activar evento de terror o quitar vida!")

# 4. Esta función se dispara solita cuando el Timer llega a 0
func _on_patience_timer_timeout() -> void:
	cambiar_estado(ClienteState.ENOJADO)
