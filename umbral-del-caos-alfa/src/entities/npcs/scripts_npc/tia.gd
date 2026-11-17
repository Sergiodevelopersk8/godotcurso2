# res://src/entities/actors/customer_npc1.gd
extends CharacterNPC # O la clase base que utilice tu NPC principal
class_name Tia

const DIALOGUE_COOLDOWN := 0.35

@export var speed: float = 2.5
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	super._ready() # Inicializa la clase padre
	
	# Nos suscribimos a la señal global del GameManager Autoload
	if GameManager.has_signal("minijuego_memelas_completado"):
		GameManager.minijuego_memelas_completado.connect(_on_minijuego_completado)
		print("[Tia] Conectada exitosamente al GameManager.")

func _physics_process(delta: float) -> void:
	# 1. Aplicamos gravedad si no está en el suelo
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 2. Verificamos si el GameManager ya activó la orden de seguir al jugador
	if GameManager.is_following_player:
		var player = get_tree().get_first_node_in_group("Player")
		if player:
			# Calculamos la dirección hacia el jugador (solo en el plano XZ)
			var target_pos = player.global_transform.origin
			var direction = (target_pos - global_transform.origin)
			direction.y = 0 
			direction = direction.normalized()
			
			if direction != Vector3.ZERO:
				# Hacemos que la Tía rote suavemente hacia el jugador
				look_at(Vector3(target_pos.x, global_transform.origin.y, target_pos.z), Vector3.UP)
				
				# Movemos a la Tía hacia el jugador
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
				velocity.z = move_toward(velocity.z, 0, speed)
	else:
		# Si aún no cumple el objetivo, se queda quieta
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()







# Si la interacción la maneja un Area3D hijo, puedes conectar su señal aquí o delegarla
func _on_interaction_area_entered(body: Node3D) -> void:
	# Lógica cuando el jugador entra al área de interacción
	pass

func _on_minijuego_completado() -> void:
	print("[Tia] ¡Las 3 memelas fueron entregadas! Cambiando a estado Walk/Persecución.")
	if state_machine and state_machine.has_method("change_state"):
		state_machine.change_state("Walk")
