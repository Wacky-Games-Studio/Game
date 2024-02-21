@icon("res://icons/checkpoint.svg")
class_name Checkpoint
extends Area2D

@export var should_face_left_on_spawn: bool = false
@export var collision_size: Vector2
@export var collider_position: Vector2

@onready var spawn_location = $SpawnLoaction
@onready var animation_player = $AnimationPlayer
@onready var checkpoint_collider = $CheckpointCollider

var spawn_pos: Vector2 = Vector2(0, 0)
var has_passed := false

func _ready() -> void:
	var rect := RectangleShape2D.new()
	rect.size = collision_size
	checkpoint_collider.shape = rect
	checkpoint_collider.global_position = collider_position
	
	spawn_pos = spawn_location.global_position
	has_passed = CheckpointManager.has_collected(self)
	
	if has_passed:
		animation_player.play("already_captured")
	else:
		animation_player.play("RESET")
	
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not has_passed:
		animation_player.play("captured")
		
		has_passed = true
		
		var data := CheckpointManager.CheckpointData.new()
		data.checkpoint = self
		data.position = spawn_pos
		data.facing_left = should_face_left_on_spawn
		data.static_camera = body.get_static_camera()
		
		CheckpointManager.collect_checkpoint(data)
