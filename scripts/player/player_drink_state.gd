class_name PlayerDrinkState
extends PlayerStateMachine


@export var locomotion_component: LocomotionComponent
@export var health_charge_component: HealthChargeComponent
@export var movement_animations: MovementAnimations

var _prev_walk_speed: float


func _ready():
	super()
	health_charge_component.finished_drinking.connect(
		func(): parent_state.transition_to_default_state()
	)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("consume_item") and \
	parent_state.current_state != PlayerDrinkState and \
	not parent_state.current_state is PlayerCheckpointState:
		parent_state.change_state(self)


func enter() -> void:
	health_charge_component.consume_health_charge()
	player.head_rotation_component.enabled = false
	locomotion_component.speed = 0.8
	_prev_walk_speed = movement_animations.speed


func process_player() -> void:
	player.set_rotation_target_to_lock_on_target()
	player.set_rotate_towards_target_if_lock_on_target()


func process_movement_animations() -> void:
	player.character.idle_animations.active = player.lock_on_target != null
	player.character.movement_animations.dir = player.input_direction
	player.character.movement_animations.set_state("walk")
	movement_animations.speed = 0.5


func exit() -> void:
	player.head_rotation_component.enabled = true
	player.health_charge_component.interupt()
	movement_animations.speed = _prev_walk_speed
