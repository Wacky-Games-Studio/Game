extends Node

var process_paused := false
var has_died := false
var checkpoints_passed := 0

func pause_process():
	process_paused = true

func start_process():
	process_paused = false

func restart_level():
	$"../SceneManager".restart_level()

func checkpoint_collected():
	checkpoints_passed += 1
