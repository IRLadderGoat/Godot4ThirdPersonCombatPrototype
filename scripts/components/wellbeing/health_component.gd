class_name HealthComponent
extends Node3D


signal took_damage
signal health_increased
signal zero_health


@export var enabled: bool = true

@export_category("Health")
@export var max_health: float = 100.0
@export var health: float = max_health:
	set(value):
		var new_value = clamp(value, 0.0, max_health)
		var old_value = health
		health = new_value
		if old_value < new_value:
			health_increased.emit()

@export_category("Particles")
@export var blood_scene: PackedScene

var deal_max_damage: bool = false


func _ready() -> void:
	health = max_health


func is_alive() -> bool:
	return health > 0


func incoming_damage(source: DamageSource) -> void:
	if not enabled: return
	decrement_health(source.damage_attributes.health)
	if blood_scene:
		var blood_particle: GPUParticles3D = blood_scene.instantiate()
		add_child(blood_particle)
		blood_particle.look_at(source.global_position)
		blood_particle.rotate_y(PI)
		blood_particle.restart()


func decrement_health(amount: float) -> void:
	if not enabled:
		return
	
	if not is_alive():
		return
	
	if deal_max_damage:
		health = 0
		deal_max_damage = false
	else:
		health -= amount
	
	took_damage.emit()
	
	if health <= 0:
		zero_health.emit()
