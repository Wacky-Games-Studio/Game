extends Area2D

var custom_data
var dir := Vector2.UP

func _ready():
	dir = custom_data
	var angle_to_rotate = dir.angle_to(Vector2.UP)
	rotate(angle_to_rotate)

func _on_body_entered(body):
	if body is Player:
		body.die()
