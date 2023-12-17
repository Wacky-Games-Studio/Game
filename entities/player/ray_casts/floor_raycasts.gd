class_name FloorRaycasts
extends Node2D

@export var right: bool
@export var left: bool

func _physics_process(_delta: float) -> void:
	right = $right.is_colliding()
	left = $left.is_colliding()
