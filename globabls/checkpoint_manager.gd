extends Node

var _checkpoints_passed: Array[String]

func collect_checkpoint(checkpoint: Area2D):
	_checkpoints_passed.push_back(checkpoint.name)

func has_collected(checkpoint: Area2D):
	return checkpoint.name in _checkpoints_passed

func spawn_at_checkpoint(level: Node2D):
	var player: Player = level.get_node("Player")
	var checkpoints_holder: Node2D = level.get_node("Checkpoints")
	var collected_checkpoints := _checkpoints_passed.size()
	
	# HACK: could be better by using the names but eh. It works
	var current_checkpoint: Area2D = checkpoints_holder.get_children()[collected_checkpoints - 1]
	
	player.global_position = current_checkpoint.spawn_pos
	player.init()

func reset():
	_checkpoints_passed.clear()
