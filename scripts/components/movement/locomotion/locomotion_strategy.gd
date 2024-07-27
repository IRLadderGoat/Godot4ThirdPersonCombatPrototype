class_name LocomotionStrategy
extends Node


@export var debug: bool = false

var strategy_name: String
var context: LocomotionComponent


func handle_movement(_delta: float) -> void:
	# this gets overridden 
	pass
