extends TileMap

@export_range(0, 1) var parallax_scale = 0.5

@onready var player = $"../Player"

func _process(_delta) -> void:
	global_position.x = player.global_position.x * parallax_scale
