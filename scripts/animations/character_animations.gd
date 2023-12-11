class_name CharacterAnimations
extends Node3D


@onready var movement_animations: MovementAnimations = $MovementAnimations
@onready var jump_animations: JumpAnimations = $JumpAnimations
@onready var attack_animations: AttackAnimations = $AttackAnimations
@onready var hit_and_death_animatinos: HitAndDeathAnimations = $HitAndDeathAnimations

@onready var anim_tree: AnimationTree = $AnimationTree


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_tree.active = true
