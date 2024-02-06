@icon("res://icons/door.svg")
class_name Door
extends StaticBody2D

@export var already_open: bool = false

func _ready():
	if already_open:
		open()

func open() -> void:
	$AnimationPlayer.play("open")
	
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(0.5).timeout
	$AudioStreamPlayer2D.stop()

func close() -> void:
	$AnimationPlayer.play("close")
