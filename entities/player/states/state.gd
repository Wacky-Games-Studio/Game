class_name State
extends Node

@export var animation_name: String
@export var speed := 200
@export var jump_speed := -450
@export var wall_jump_pushback := -225
@export var gravity := 2000
@export var wall_slide_gravity := 100
@export_range(0.0, 1.0) var friction := 0.3
@export_range(0.0 , 1.0) var acceleration := 0.4

# Hold a reference to the parent so that it can be controlled by the state
var parent: Player

func enter() -> void:
	#parent.animations.play(animation_name)
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
