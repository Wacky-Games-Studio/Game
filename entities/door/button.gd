@icon("res://icons/button.svg")
class_name DuckButton
extends StaticBody2D

@export var door: Door

func _on_area_2d_body_entered(_body: Node2D) -> void:
	$Sprite2D.frame = 1
	$AudioStreamPlayer2D.play()
	$Area2D.queue_free()
	door.open()
