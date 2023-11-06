class_name PausableEntity
extends CharacterBody2D

func _unhandled_input(event: InputEvent) -> void:
	if SceneManager.scene_paused: return
	unhandled_input(event)

func _process(delta: float) -> void:
	if SceneManager.scene_paused: return
	process(delta)

func _physics_process(delta: float) -> void:
	if SceneManager.scene_paused: return
	physics_process(delta)

func unhandled_input(event: InputEvent) -> void: pass
func process(delta: float) -> void: pass
func physics_process(delta: float) -> void: pass
 
