extends Area2D

@export var static_camera := false

func _on_body_entered(body):
	if body is Player:
		body.toggle_camera(static_camera)
