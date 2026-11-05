# res://src/entities/actors/customer_npc1.gd
extends CharacterNPC # O la clase base que utilice tu NPC principal
class_name Tia

const DIALOGUE_COOLDOWN := 0.35

func _ready() -> void:
	super._ready() # Inicializa la clase padre
	
	# Nos suscribimos a la señal global del GameManager Autoload
	if GameManager.has_signal("minijuego_memelas_completado"):
		GameManager.minijuego_memelas_completado.connect(_on_minijuego_completado)
		print("[Tia] Conectada exitosamente al GameManager.")

# Si la interacción la maneja un Area3D hijo, puedes conectar su señal aquí o delegarla
func _on_interaction_area_entered(body: Node3D) -> void:
	# Lógica cuando el jugador entra al área de interacción
	pass

func _on_minijuego_completado() -> void:
	print("[Tia] ¡Las 3 memelas fueron entregadas! Cambiando a estado Walk/Persecución.")
	if state_machine and state_machine.has_method("change_state"):
		state_machine.change_state("Walk")
