extends Node

var scene_paused: bool = false

func restart_level():
	FadeTransition.transition()
	await FadeTransition.transitioned

	get_tree().reload_current_scene()
	
	FadeTransition.remove_transition()
