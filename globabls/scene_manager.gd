extends Node

signal ScenePaused()
signal SceneStarted()

var scene_paused: bool = false
var player: Player

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
	
	var next_level_path = "res://ldtk_levels/worlds/Level_" + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
	
	FadeTransition.remove_transition()

func change_level(level: String) -> void:
	FadeTransition.transition()
	await FadeTransition.transitioned
	
	CheckpointManager.reset()
	
	var next_level_path = "res://ldtk_levels/worlds/Level_" + level + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
	
	FadeTransition.remove_transition()

func change_level_specific(level: String, transition_in: bool, transition_out: bool) -> void:
	if transition_in:
		FadeTransition.transition()
		await FadeTransition.transitioned
	
	CheckpointManager.reset()
	
	get_tree().change_scene_to_file(level)
	
	if transition_out:
		FadeTransition.remove_transition()

func pause_scene():
	emit_signal("ScenePaused")
	scene_paused = true

func start_scene():
	emit_signal("SceneStarted")
	scene_paused = false
