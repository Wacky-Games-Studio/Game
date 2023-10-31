extends Node

var camera_moving := false

func pause_process():
	camera_moving = true

func start_process():
	camera_moving = false

func restart_level():
	$"../SceneManager".restart_level()
