extends TileMap

@export var spikes: PackedScene
@export var springs: PackedScene

func _ready():
	replace_tiles(2, 0, spikes)
	replace_tiles(3, 0, springs)


func replace_tiles(atlas: int, layer: int, type: PackedScene):
	var positions = get_used_cells(layer)
	for pos in positions:
		var tile := get_cell_tile_data(layer, pos)
		if tile == null: continue
		
		var tile_atlas = get_cell_source_id(layer, pos)
		if tile_atlas != atlas: continue
		
		var tile_dir: Vector2 = tile.get_custom_data("direction")
		
		var instance = type.duplicate().instantiate()
		instance.dir = tile_dir
		instance.global_position = to_global(map_to_local(pos))
		add_child(instance)
		
		set_cell(layer, pos)
