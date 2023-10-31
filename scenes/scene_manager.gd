class_name SceneManager
extends Node2D

@export var levels: Array[PackedScene]

@onready var current_scene: Node2D = $CurrentScene
@onready var transition_screen = $TransitionScreen

var level_index := 0

func restart_level():
	transition_screen.transition()
	await transition_screen.transitioned
	
	current_scene.get_child(0).queue_free()
	
	var level = levels[level_index].duplicate().instantiate()
	current_scene.add_child(level)
	
	transition_screen.remove_transition()
