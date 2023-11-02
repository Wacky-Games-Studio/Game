extends Node2D

var custom_data
var new_scale := Vector2.UP
func _ready():
	new_scale = custom_data
	
	if new_scale == Vector2(10, 10):
		var wall_torch = load("res://entities/torch/wall/wall_torch.tscn").instantiate()
		wall_torch.global_position = global_position
		$"..".add_child(wall_torch)
		queue_free()
		return
	
	scale = new_scale
