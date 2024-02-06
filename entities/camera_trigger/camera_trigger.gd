@icon("res://icons/trigger.svg")
extends Area2D

@export var enable_static_camera_on_left_side := true

var entered_left: bool

func _on_body_entered(body):
	if body is Player:
		var player_pos: float = body.global_position.x
		var pos := global_position.x
		entered_left = player_pos < pos

func _on_body_exited(body):
	if body is Player:
		var player_pos: float = body.global_position.x
		var pos := global_position.x
		var exited_left = player_pos < pos
		var exited_right = not exited_left
		var entered_right = not entered_left
		
		if entered_left:
			if exited_left: body.set_static(enable_static_camera_on_left_side)
			elif exited_right: body.set_static(not enable_static_camera_on_left_side)
		elif entered_right:
			if exited_left: body.set_static(enable_static_camera_on_left_side)
			elif exited_right: body.set_static(not enable_static_camera_on_left_side)
