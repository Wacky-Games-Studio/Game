extends Marker2D

@onready var player: Player = $".."

func _process(delta):
	var target := player.global_position
	var target_pos_x := int(lerp(global_position.x, target.x, 2 * delta))
	var target_pos_y := int(lerp(global_position.y, target.y, 2 * delta))
	
	global_position = Vector2(target_pos_x, target_pos_y)
