@tool
extends Node2D

@export var bound := 10
@export var screen_size: Vector2 = Vector2(320, 176)
@export var color: Color = Color.PURPLE
@export var size: int = 1

func _ready():
	if not Engine.is_editor_hint():
		queue_free()

func _draw():
	if not Engine.is_editor_hint(): return
	
	var x_bound: float = bound * screen_size.x
	var y_bound: float = bound * screen_size.y
	
	for y in range(-y_bound, y_bound + screen_size.y, screen_size.y):
		draw_line(Vector2(-x_bound, y), Vector2(x_bound, y), color, size)
		for x in range(-x_bound, x_bound + screen_size.x, screen_size.x):
			draw_line(Vector2(x, -y_bound), Vector2(x, y_bound), color, size)
