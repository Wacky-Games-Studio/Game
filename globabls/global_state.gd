extends Node

# FIXME: This entire class is dumb, needs rewrite

var process_paused := false
var has_died := false

func pause_process():
	process_paused = true

func start_process():
	process_paused = false

func restart_level():
	$"../SceneManager".restart_level()

func finnish_level():
	$"../SceneManager".finnish_level()
