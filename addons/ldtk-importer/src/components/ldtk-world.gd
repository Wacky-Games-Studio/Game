@icon("ldtk-world.svg")
class_name LDTKWorld
extends Node2D
const PLAYER = preload("res://entities/player/player.tscn")
@export var rect: Rect2i

func _ready():
	add_child(PLAYER.instantiate())
