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
			
			var tile_data: Vector2 = tile.get_custom_data("direction")
			
			var instance = spikes.duplicate().instantiate()
			instance.global_position = to_global(map_to_local(Vector2(x, y)))
			add_child(instance)
			
			set_cell(2, Vector2i(x, y))

			
#			match tile_dir:
#				Vector2(-1,0):
#

			#if tile_id == tile_id_to_replace:
			#	var instance = packed_scene.instance()
			#	instance.position = map_to_world(Vector2(x, y))
			#	get_tree().get_root().add_child(instance)  # Add the packed scene to the root of the scene tree
			#	tilemap.set_cell(x, y, -1)  # Remove the original tile by setting it to -1

