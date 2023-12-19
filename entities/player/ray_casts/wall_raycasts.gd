class_name WallRaycasts
extends Node2D

@export var right: bool
@export var right_middle: bool
@export var right_bottom: bool
@export var left: bool
@export var left_middle: bool
@export var left_bottom: bool

func _physics_process(_delta: float) -> void:
	right = $right.is_colliding()
	right_middle = $rightmiddle.is_colliding()
	right_bottom = $rightbottom.is_colliding()
	left = $left.is_colliding()
	left_middle = $leftmiddle.is_colliding()
	left_bottom = $leftbottom.is_colliding()
