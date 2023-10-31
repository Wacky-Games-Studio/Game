extends TileMap

@export var spikes: PackedScene

func _ready():
	add_spikes()

func add_spikes():
	var map_size = get_used_rect().size
	for x in range(map_size.x):
		for y in range(map_size.y):
			var tile := get_cell_tile_data(2, Vector2i(x, y))
			if tile == null: continue
			
			var tile_dir: Vector2 = tile.get_custom_data("direction")
			
			var instance = spikes.duplicate().instantiate()
			instance.dir = tile_dir
			instance.global_position = to_global(map_to_local(Vector2(x, y)))
			add_child(instance)
			
			set_cell(2, Vector2i(x, y))
