# res://src/entities/actors/customer_npc1.gd
extends CharacterBody3D
class_name CharacterNPC

@export_group("Movimiento")
@export var movement_speed: float = 2.5
@export var dialogue_resource: DialogueResource

@export var idName: String

@onready var interaccion: Interact = $Interact
@onready var nav_agent: NavigationAgent3D = $nav_agent
@onready var state_machine: Node = $NPCStateMachine

var is_dialogue_active: bool = false
var can_start_dialogue: bool = true
var current_player: Player = null

func _ready() -> void:
	if interaccion:
		interaccion.id = idName
		interaccion.can_be_loaded = false
		if not interaccion.isInteract.is_connected(_on_interactuado):
			interaccion.isInteract.connect(_on_interactuado)

	if state_machine:
		state_machine.init(self)

func _process(delta: float) -> void:
	if state_machine:
		if state_machine.has_method("update"):
			state_machine.update(delta)

func _physics_process(delta: float) -> void:
	if state_machine:
		if state_machine.has_method("physics_update"):
			state_machine.physics_update(delta)

func set_destination(target_position: Vector3) -> void:
	nav_agent.target_position = target_position

func _on_interactuado() -> void:
	if not can_start_dialogue:
		return

	if state_machine:
		state_machine.change_state("InDialogue")
