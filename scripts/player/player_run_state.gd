class_name PlayerRunState
extends PlayerStateMachine


@export var movement_state: PlayerMovementState
@export var idle_state: PlayerIdleState
@export var walk_state: PlayerWalkState
@export var jump_state: PlayerJumpState


func enter() -> void:
	player.movement_component.speed = 5


func process_player() -> void:
	if player.input_direction.length() < 0.2:
		parent_state.change_state(idle_state)
	
	if not movement_state.holding_down_run:
		parent_state.change_state(walk_state)
	
	if Input.is_action_just_pressed("jump") and \
	player.is_on_floor():
		parent_state.change_state(jump_state)
	
	
	if player.lock_on_target and player.input_direction.z <= 0:
		player.rotation_component.rotate_towards_target = true
	else:
		player.rotation_component.rotate_towards_target = false
