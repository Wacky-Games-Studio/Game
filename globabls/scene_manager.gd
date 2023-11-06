extends Node

var scene_paused: bool = false

func restart_level() -> void:
	FadeTransition.transition()
	await FadeTransition.transitioned

	get_tree().reload_current_scene()
	
	FadeTransition.remove_transition()

func finnish_level() -> void:
	FadeTransition.transition()
	await FadeTransition.transitioned
	
	CheckpointManager.reset()
	
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	
	var next_level_path = "res://scenes/levels/level_" + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
	
	FadeTransition.remove_transition()
