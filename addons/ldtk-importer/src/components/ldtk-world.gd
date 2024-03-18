@icon("ldtk-world.svg")
class_name LDTKWorld
extends Node2D

const PLAYER = preload("res://entities/player/player.tscn")
const ONE_WAY_FACTORY = preload("res://entities/platforms/oneway/one_way_factory.png")

@export var rect: Rect2i

func _ready():
	add_child(PLAYER.instantiate())

	var oneways = get_tree().get_nodes_in_group("Oneway")
	if oneways.size() == 0 or oneways[0].get_parent().name != "Factory":
		return
	
	for oneway in oneways:
		oneway.get_node("Sprite2D").texture = ONE_WAY_FACTORY
