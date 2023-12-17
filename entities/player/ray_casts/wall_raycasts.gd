class_name WallRaycasts
extends Node2D

@export var right: bool
@export var left: bool

func _physics_process(delta: float) -> void:
	right = $right.is_colliding()
	left = $left.is_colliding()
