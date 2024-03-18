extends Node2D

@export var level: String = "1"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().change_scene_to_file("res://ldtk_levels/worlds/Level_" + level + ".tscn")
	# add_child(load("res://ldtk_levels/worlds/Level_" + level + ".tscn").instantiate())

