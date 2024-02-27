@icon("res://icons/lock.svg")
class_name CameraLocker
extends Area2D

@export var lock_left : bool = false
@export var lock_right: bool = false
@export var lock_up   : bool = false
@export var lock_down : bool = false
@export var collision_size: Vector2
@export var collider_position: Vector2

@onready var collider: CollisionShape2D = $CollisionShape2D

var movement_flags = 0

func _ready():
	var rect := RectangleShape2D.new()
	rect.size = collision_size
	$CollisionShape2D.shape = rect
	$CollisionShape2D.position = collider_position
	
	if lock_left : movement_flags |= 1 << 0
	if lock_right: movement_flags |= 1 << 1
	if lock_up   : movement_flags |= 1 << 2
	if lock_down : movement_flags |= 1 << 3
	
	var size := collider.shape.get_rect().size
	var screen_size := get_viewport().get_visible_rect().size
	if size < screen_size:
		push_warning("Camera locker collider is smaller than screen size")
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if not body is Player:
		return
	
	var rect = collider.shape.get_rect()
	rect.position = collider.global_position
	body.restrict_camera(rect, movement_flags, self)


func _on_body_exited(body):
	if body is Player:
		body.restrict_camera(Rect2(0,0,0,0), movement_flags, self)
