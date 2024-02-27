extends Node2D

const level1 = preload("res://ldtk_levels/worlds/Level_1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(level1.instantiate())

