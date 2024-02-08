@icon("res://icons/trigger.svg")
extends Area2D

@export var static_side := StaticSide.Left

var entered_left: bool
var entered_top: bool

func _on_body_entered(body):
	if body is Player:
		var player_pos: Vector2 = body.global_position
		var pos := global_position
		entered_left = player_pos.x < pos.x
		entered_top = player_pos.y < pos.y

func _on_body_exited(body):
	if body is Player:
		var player_pos: Vector2 = body.global_position
		var pos := global_position
		
		#horizontal
		var exited_left = player_pos.x < pos.x
		var exited_right = not exited_left
		var entered_right = not entered_left
		
		# vertical
		var exited_top = player_pos.y < pos.y
		var exited_bottom = player_pos.y < pos.y
		var entered_bottom = not entered_top
		
		if static_side in [StaticSide.Left, StaticSide.Right]:
			if entered_left:
				if exited_left: body.set_static(static_side == StaticSide.Left)
				elif exited_right: body.set_static(static_side != StaticSide.Left)
			elif entered_right:
				if exited_left: body.set_static(static_side == StaticSide.Left)
				elif exited_right: body.set_static(static_side != StaticSide.Left)
		elif static_side in [StaticSide.Top, StaticSide.Down]:
			if entered_top:
				if exited_top: body.set_static(static_side == StaticSide.Top)
				elif exited_bottom: body.set_static(static_side != StaticSide.Top)
			elif entered_bottom:
				if exited_top: body.set_static(static_side == StaticSide.Top)
				elif exited_bottom: body.set_static(static_side != StaticSide.Top)

enum StaticSide {
	Top, Down, Left, Right
}
