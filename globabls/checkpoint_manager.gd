extends Node

class CheckpointData:
	var checkpoint: Checkpoint
	var position: Vector2
	var facing_left: bool

var _checkpoints_passed: Array[String]
var _checkpoint_data: Dictionary

func collect_checkpoint(data: CheckpointData):
	_checkpoints_passed.push_back(data.checkpoint.name)
	_checkpoint_data[data.checkpoint.name] = data

func has_collected(checkpoint: Checkpoint):
	return checkpoint.name in _checkpoints_passed

func has_collected_any():
	return _checkpoints_passed.size() > 0

func spawn_at_checkpoint():
	var level := get_tree().current_scene
	var player: Player = level.get_node("Player")
	var checkpoints_holder: Node2D = level.get_node("Checkpoints")
	var collected_checkpoints := _checkpoints_passed.size()
	
	# HACK: could be better by using the names but eh. It works
	var current_checkpoint: Area2D = checkpoints_holder.get_children()[collected_checkpoints - 1]
	
	player.global_position = current_checkpoint.spawn_pos
	player.init()

func get_latest_checkpoint() -> Checkpoint:
	var level := get_tree().current_scene
	var checkpoints_holder: Node2D = level.get_node("Checkpoints")
	var collected_checkpoints := _checkpoints_passed.size()
	
	# HACK: could be better by using the names but eh. It works
	return checkpoints_holder.get_children()[collected_checkpoints - 1]

func get_latest_checkpoint_data() -> CheckpointData:
	if _checkpoints_passed.size() == 0:
		var position = get_tree().current_scene.get_node("PlayerSpawn").global_position
		var data = CheckpointData.new()
		data.position = position
		data.checkpoint = null
		data.facing_left = false
		return data
	
	var level := get_tree().current_scene
	var checkpoints_holder: Node2D = level.get_node("Checkpoints")
	var collected_checkpoints := _checkpoints_passed.size()
	
	var current_checkpoint: Area2D = checkpoints_holder.get_node(_checkpoints_passed.back())
	
	return _checkpoint_data[current_checkpoint.name]


func reset():
	_checkpoints_passed.clear()
	_checkpoint_data.clear()
