class_name AttackComponent
extends Node3D

signal attacking(active: bool)
signal can_rotate(flag: bool)

@export var character: PlayerAnimations
@export var attack_level = 1
@export var can_attack = true
@export var can_attack_again = false

# Called when the node enters the scene tree for the first time.
func _ready():
	character.movement_animations.can_rotate.connect(_receive_rotation)
	character.attack_animations.attacking_finished.connect(_attacking_finished)
	character.attack_animations.can_attack_again.connect(_receive_can_attack_again)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("attack"):
		_attack()

func _attack():
	if can_attack or can_attack_again:
		can_attack = false
		attacking.emit(true)
		
		if can_attack_again and attack_level < 4:
			can_attack_again = false
			attack_level += 1
		else:
			attack_level = 1
		
		character.attack_animations.attack(attack_level)
	
		
func _receive_can_attack_again(flag: bool):
	can_attack_again = flag

func _attacking_finished():
	attacking.emit(false)
	can_attack_again = false
	can_attack = true
	attack_level = 1

func _receive_rotation(flag: bool):
	can_rotate.emit(flag)