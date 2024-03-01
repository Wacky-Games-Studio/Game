extends Node2D

@export var level: String = "1"
#const level1 = preload("res://ldtk_levels/worlds/Level_1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(load("res://ldtk_levels/worlds/Level_" + level + ".tscn").instantiate())
