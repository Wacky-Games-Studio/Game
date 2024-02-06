@icon("res://icons/lock.svg")
extends Area2D

@export var lock_left : bool = false
@export var lock_right: bool = false
@export var lock_up   : bool = false
@export var lock_down : bool = false

@onready var collider: CollisionShape2D = $CollisionShape2D

var movement_flags = 0

func _ready():
	if lock_left : movement_flags |= 1 << 0
	if lock_right: movement_flags |= 1 << 1
	if lock_up   : movement_flags |= 1 << 2
	if lock_down : movement_flags |= 1 << 3
	
	var size := collider.shape.get_rect().size
	var screen_size := get_viewport().get_visible_rect().size
	if size < screen_size:
		push_warning("Camera locker collider is smaller than screen size")

func _on_body_entered(body):
	if not body is Player:
		return
	
	var rect = collider.shape.get_rect()
	rect.position = collider.global_position
	body.restrict_camera(rect, movement_flags)


func _on_body_exited(body):
	if body is Player:
		body.restrict_camera(Rect2(0,0,0,0), movement_flags)
