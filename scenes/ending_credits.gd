extends Node2D

@export var speed = 10

@onready var canvas_layer = $CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	canvas_layer.offset.y -= speed * delta

	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
