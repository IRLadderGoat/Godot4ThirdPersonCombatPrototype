class_name CharacterAnimations
extends Node3D


@export var debug: bool = false
@export var visibility_notifier: VisibleOnScreenNotifier3D
@export var can_set_anim_tree_active: bool = true

var _recipients: Dictionary

@onready var animations: Node = $Animations
@onready var audio: Node = $Audio
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree


func _ready() -> void:
	anim_player.active = true
	anim_tree.active = true
	
	_add_base_recipient(animations)
	_add_base_recipient(audio)
	
	if debug:
		for i in _recipients:
			print(i)
		for i in anim_tree.get_property_list():
			print(i)
	
	if visibility_notifier:
		visibility_notifier.screen_entered.connect(
			func():
				if not can_set_anim_tree_active: return
				anim_player.active = true
				anim_tree.active = true
		)
		visibility_notifier.screen_exited.connect(
			func():
				if not can_set_anim_tree_active: return
				anim_player.active = false
				anim_tree.active = false
		)


func execute(target: String, method: StringName, args) -> void:
	if debug: prints("EXECUTE", target, method, args)
	
	if not _recipients.has(target):
		if debug: prints("DOES NOT CONTAIN", target)
		return
	
	var node: Node = _recipients[target]
	
	if not node.has_method(method):
		if debug: prints(target, "HAS NO METHOD", method)
		return
	
	if args == null:
		args = []
	
	node.callv(method, args)


func _add_base_recipient(node: Node) -> void:
	_add_recipients(node, node.get_parent())


func _add_recipients(node: Node, root: Node) -> void:
	if node.get_parent() != root:
		if not (node is BaseAnimations or node is AudioStreamPlayer3D):
			return
		_recipients[str(root.get_path_to(node))] = node
	for child in node.get_children():
		_add_recipients(child, root)
