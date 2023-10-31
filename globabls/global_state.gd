extends Node

var process_paused := false

func pause_process():
	process_paused = true

func start_process():
	process_paused = false

func restart_level():
	$"../SceneManager".restart_level()
