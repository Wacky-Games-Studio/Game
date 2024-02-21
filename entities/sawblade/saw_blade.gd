@icon("res://icons/sawblade.svg")
class_name Sawblade
extends Area2D

func _on_body_entered(body) -> void:
	if body is Player:
		body.die()
