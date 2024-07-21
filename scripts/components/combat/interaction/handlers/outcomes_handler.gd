class_name OutcomesInteractionHandler
extends InteractionHandler


@export var beehave_tree: BeehaveTree
@export var blackboard: Blackboard
@export var outcome_weights: Array[float]
@export var locomotion_component: LocomotionComponent
@export var notice_component: NoticeComponent

var _cumulative_weights: Array[float]
var _total_weight: float


func _ready() -> void:
	_cumulative_weights.append(outcome_weights[0])
	
	for i in range(1, len(outcome_weights)):
		_cumulative_weights.append(
			_cumulative_weights[i - 1] + outcome_weights[i]
		)
	
	_total_weight = outcome_weights.reduce(
		func(accum, number): return accum + number
	)


func handle_interaction(incoming_damage_source: DamageSource) -> bool:
	interaction.emit()
	
	blackboard.set_value("can_attack", false)
	blackboard.set_value("attack", false)
	beehave_tree.interrupt()
	
	locomotion_component.knockback(
		incoming_damage_source.damage_attributes.knockback,
		incoming_damage_source.entity.global_position
	)
	
	var rng: float = RandomNumberGenerator.new().randf() * _total_weight
	
	if blackboard.get_value("notice_state") != "aggro" or \
	blackboard.get_value("dizzy"):
		rng = 0.0
	
	var which_outcome: int = 0
	
	prints(outcome_weights, _cumulative_weights, _total_weight, rng)
	
	for i in range(len(_cumulative_weights)):
		if rng <= _cumulative_weights[i]:
			which_outcome = i
			break
	
	var handler: InteractionHandler = get_child(which_outcome)
	handler.handle_interaction(incoming_damage_source) 
	
	notice_component.transition_to_aggro()
	
	return true
