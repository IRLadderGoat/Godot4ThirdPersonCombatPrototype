class_name DodgeComponent
extends Node3D

@export var entity: Player
@export var movement_component: MovementComponent

var dodging: bool = false
var can_dodge: bool = true

var intent_to_dodge: bool = false
var can_set_intent_to_dodge: bool = true


func _physics_process(_delta: float) -> void:
	if can_dodge and intent_to_dodge:
		_dodge()


func _dodge() -> void:
	if entity.is_on_floor():
		intent_to_dodge = false
		can_set_intent_to_dodge = false
		can_dodge = false
		dodging = true

		if movement_component.move_direction.length() > 0.0:
			movement_component.desired_velocity += movement_component.move_direction.normalized() * 8
		else:			
			movement_component.desired_velocity += movement_component.looking_direction.normalized() * 8

		# how long the dodge status lasts
		var dodge_timer: SceneTreeTimer = get_tree().create_timer(0.2)
		# after this time, presing dodge again will dodge as soon as possible
		var register_next_dodge_timer: SceneTreeTimer = get_tree().create_timer(0.3)
		# this is the time it takes for the next dodge to actually occur
		var can_dodge_timer: SceneTreeTimer = get_tree().create_timer(0.8)

		dodge_timer.connect("timeout", _finish_dodging)
		register_next_dodge_timer.connect("timeout", _register_next_dodge_input)
		can_dodge_timer.connect("timeout", _can_dodge_again)


func _finish_dodging() -> void:
	dodging = false


func _register_next_dodge_input() -> void:
	can_set_intent_to_dodge = true


func _can_dodge_again() -> void:
	can_dodge = true
