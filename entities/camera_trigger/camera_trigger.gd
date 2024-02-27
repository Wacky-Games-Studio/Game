@icon("res://icons/trigger.svg")
class_name CameraTrigger
extends Area2D

@export var static_side := StaticSide.Left

@export var collision_size: Vector2
@export var collider_position: Vector2

var _entered_left: bool
var _entered_top: bool

func _ready() -> void:
	var rect := RectangleShape2D.new()
	rect.size = collision_size
	$CollisionShape2D.shape = rect
	$CollisionShape2D.position = collider_position
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is Player:
		var player_pos: Vector2 = body.global_position
		var pos := global_position
		_entered_left = player_pos.x < pos.x
		_entered_top = player_pos.y < pos.y

func _on_body_exited(body):
	if body is Player:
		var player_pos: Vector2 = body.global_position
		var pos := global_position
		
		#horizontal
		var exited_left = player_pos.x < pos.x
		var exited_right = not exited_left
		var entered_right = not _entered_left
		
		# vertical
		var exited_top = player_pos.y < pos.y
		var exited_bottom = not exited_top
		var entered_bottom = not _entered_top
		
		if static_side in [StaticSide.Left, StaticSide.Right]:
			if _entered_left:
				if exited_left: body.set_static(static_side == StaticSide.Left)
				elif exited_right: body.set_static(static_side != StaticSide.Left)
			elif entered_right:
				if exited_left: body.set_static(static_side == StaticSide.Left)
				elif exited_right: body.set_static(static_side != StaticSide.Left)
		elif static_side in [StaticSide.Top, StaticSide.Down]:
			if _entered_top:
				if exited_top: body.set_static(static_side == StaticSide.Top)
				elif exited_bottom: body.set_static(static_side != StaticSide.Top)
			elif entered_bottom:
				if exited_top: body.set_static(static_side == StaticSide.Top)
				elif exited_bottom: body.set_static(static_side != StaticSide.Top)

enum StaticSide {
	Top, Down, Left, Right
}
