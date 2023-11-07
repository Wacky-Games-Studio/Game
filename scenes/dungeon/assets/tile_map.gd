extends TileMap

@export var spikes: PackedScene
@export var springs: PackedScene
@export var sawblade: PackedScene
@export var torches: PackedScene

func _ready() -> void:
	replace_tiles(2, 0, spikes, "direction")
	replace_tiles(3, 0, springs, "direction")
	replace_tiles(4, 0, sawblade)
	replace_tiles(5, 0, torches, "direction")


func replace_tiles(atlas: int, layer: int, type: PackedScene, custom_data: String = "") -> void:
	var positions = get_used_cells(layer)
	for pos in positions:
		var tile := get_cell_tile_data(layer, pos)
		if tile == null: continue
		
		var tile_atlas = get_cell_source_id(layer, pos)
		if tile_atlas != atlas: continue
		
		
		var instance = type.duplicate().instantiate()
		if custom_data != "":
			var data = tile.get_custom_data(custom_data)
			instance.custom_data = data
		instance.global_position = to_global(map_to_local(pos))
		add_child(instance)
		
		set_cell(layer, pos)
