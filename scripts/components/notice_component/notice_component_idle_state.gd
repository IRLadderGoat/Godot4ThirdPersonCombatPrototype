class_name NoticeComponentIdleState
extends NoticeComponentState


@export var getting_suspicious_state: NoticeComponentGettingSuspiciousState
@export var aggro_state: NoticeComponentAggroState


func enter() -> void:
	notice_component.notice_triangle.visible = false
	notice_component.notice_triangle.self_modulate = Color.WHITE
	notice_component.notice_triangle.inner_triangle.self_modulate = \
		notice_component.suspicion_color
	notice_component.notice_triangle.background_triangle.self_modulate = \
		notice_component.background_color
	
	notice_component.off_camera_notice_triangle.visible = false
	notice_component.off_camera_notice_triangle.triangle_arc_base\
		.self_modulate = Color.WHITE
	notice_component.off_camera_notice_triangle.inner_triangle\
		.self_modulate = notice_component.suspicion_color
	notice_component.off_camera_notice_triangle.background_triangle\
		.self_modulate = notice_component.background_color
	
	notice_component.blackboard.set_value(
		"agent_target_position",
		null
	)


func physics_process(_delta) -> void:
	notice_component.notice_triangle.process_mask_offset(0.0)
	notice_component.off_camera_notice_triangle.process_mask_offsets(0.0)
	
	if notice_component.inside_inner_threshold():
		notice_component.transition_to_aggro()
		return
	elif notice_component.inside_outer_threshold():
		notice_component.change_state(getting_suspicious_state)


func exit() -> void:
	pass
