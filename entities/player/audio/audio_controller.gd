extends Node

@export var walk_sounds: AudioStreamPlayer2D
@export var jump_land_sounds: AudioStreamPlayer2D

func play_walk() -> void:
	walk_sounds.play()

func play_jump_land() -> void:
	jump_land_sounds.play()
