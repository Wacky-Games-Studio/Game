@tool

func post_import(world: LDTKWorld) -> LDTKWorld:
	# Behaviour goes here
	
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
