class_name BlockInteractionHandler
extends InteractionHandler


@export var blackboard: Blackboard
@export var shield_component: ShieldComponent
@export var health_component: HealthComponent
@export var instability_component: InstabilityComponent
@export var block_sfx: AudioStreamPlayer3D


func handle_interaction(incoming_damage_source: DamageSource) -> bool:
	interaction.emit()
	
	shield_component.blocking = true
	shield_component.blocked()
	if block_sfx: block_sfx.play()
	
	instability_component.increment_instability(
		incoming_damage_source.damage_attributes.block_instability
	)
	instability_component.enabled = false
	health_component.enabled = false
	get_tree().create_timer(0.3).timeout.connect(
		func():
			shield_component.blocking = false
			instability_component.enabled = true
			health_component.enabled = true
	)
	
	return true
