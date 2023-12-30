class_name CeilingRaycasts
extends Node2D

@export var left_outer: bool
@export var left_inner: bool
@export var right_outer: bool
@export var right_inner: bool

func _physics_process(_delta: float) -> void:
	left_outer = $left_outer.is_colliding()
	left_inner = $left_inner.is_colliding()
	right_outer = $right_outer.is_colliding()
	right_inner = $right_inner.is_colliding()