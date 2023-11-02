class_name SceneManager
extends Node2D

@export var levels: Array[PackedScene]

@onready var current_scene: Node2D = $CurrentScene
@onready var transition_screen = $TransitionScreen

var level_index := 0

func _ready():
	var level = levels[level_index].duplicate().instantiate()
	current_scene.add_child(level)

func restart_level():
	transition_screen.transition()
	await transition_screen.transitioned
	
	GlobalState.has_died = true
	
	current_scene.get_child(0).queue_free()
	
	await current_scene.get_child_count() > 0
	
	var level = levels[level_index].duplicate().instantiate()
	current_scene.add_child(level)
	
	# spawn the player at checkpoint
	if GlobalState.checkpoints_passed != 0:
		spawn_at_checkpoint(level)
	
	transition_screen.remove_transition()

func spawn_at_checkpoint(level: Node2D):
	var player: Player = level.get_node("Player")
	var checkpoints_holder: Node2D = level.get_node("Checkpoints")
	var current_checkpoint: Area2D = checkpoints_holder.get_children()[GlobalState.checkpoints_passed - 1]
	
	player.global_position = current_checkpoint.global_position + (current_checkpoint.spawn_pos as Vector2)
	player.get_node("Camera").update_position()
