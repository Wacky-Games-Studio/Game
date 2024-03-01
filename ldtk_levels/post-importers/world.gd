@tool

func post_import(world: LDTKWorld) -> LDTKWorld:
	# Behaviour goes here
	handle_one_ways(world)
	
	var save = PackedScene.new()
	save.pack(world)
	
	var base_dir := "res://ldtk_levels/worlds/"
	DirAccess.make_dir_recursive_absolute(base_dir)
	
	var file_path := base_dir + world.name + ".tscn"
	if FileAccess.file_exists(file_path):
		DirAccess.remove_absolute(file_path)
		print("Deleting file: ", file_path)
	
	print("Saving to: ", file_path)
	var error := ResourceSaver.save(save, file_path)

	return world

func find_children_with_name(root_node: Node, name_to_find: String) -> Array[Node]:
	var children_with_name: Array[Node] = []

	# Check if the current node has the desired name
	if root_node.name == name_to_find:
		children_with_name.append(root_node)

	# Check all children recursively
	for i in range(root_node.get_child_count()):
		var child = root_node.get_child(i)
		var children_of_child: Array[Node] = find_children_with_name(child, name_to_find)
		children_with_name.append_array(children_of_child)

	return children_with_name

const ONEWAYTILEPOSMIN = Vector2i(22, 0)
const ONEWAYTILEPOSMAX = Vector2i(25, 3)

const ONE_WAY_UP_LEFT = preload("res://entities/platforms/oneway/Up/one_way_up_left.tscn")
const ONE_WAY_UP_MIDDLE = preload("res://entities/platforms/oneway/Up/one_way_up_middle.tscn")
const ONE_WAY_UP_RIGHT = preload("res://entities/platforms/oneway/Up/one_way_up_right.tscn")
const ONE_WAY_UP = preload("res://entities/platforms/oneway/Up/one_way_up.tscn")

func handle_one_ways(world: LDTKWorld):
	var dungeon_nodes: Array[Node] = find_children_with_name(world, "Dungeon")
	var dungeon_tile_maps: Array[TileMap] = []
	
	for node in dungeon_nodes:
		dungeon_tile_maps.append(node as TileMap)
	
	for dungeon in dungeon_tile_maps:
		replace_tiles(dungeon, 2, 1)

func replace_tiles(tilemap: TileMap, atlas: int, layer: int) -> void:
	var positions = tilemap.get_used_cells(layer)
	for pos in positions:
		var tile := tilemap.get_cell_tile_data(layer, pos)
		if tile == null: continue
		
		var tile_atlas = tilemap.get_cell_source_id(layer, pos)
		if tile_atlas != atlas: continue
		
		var atlas_coord = tilemap.get_cell_atlas_coords(layer, pos)
		if not is_atlas_cord_in_range(atlas_coord): continue
		
		atlas_coord.x -= ONEWAYTILEPOSMIN.x
		
		var oneway: Node2D
		
		if atlas_coord.y == 0:
			match atlas_coord.x:
				0: oneway = ONE_WAY_UP.instantiate()
				1: oneway = ONE_WAY_UP_MIDDLE.instantiate()

		if atlas_coord.y == 1:
			match atlas_coord.x:
				0: oneway = ONE_WAY_UP_LEFT.instantiate()
				1: oneway = ONE_WAY_UP_RIGHT.instantiate()
		
		oneway.global_position = tilemap.to_global(tilemap.map_to_local(pos))
		tilemap.add_child(oneway)
		
		tilemap.set_cell(layer, pos)


func is_atlas_cord_in_range(vector_to_check: Vector2) -> bool:
	return (vector_to_check.x >= ONEWAYTILEPOSMIN.x and vector_to_check.x <= ONEWAYTILEPOSMAX.x) and \
		(vector_to_check.y >= ONEWAYTILEPOSMIN.y and vector_to_check.y <= ONEWAYTILEPOSMAX.y)
