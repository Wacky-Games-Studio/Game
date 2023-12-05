class_name Spring
extends Area2D

@export var jump_height: float = 100
@export var side_spring_jump_height: float = 50
@export var jump_time_to_peak: float = .5

@onready var jump_velocity := (( 2.0 * jump_height) / jump_time_to_peak)
@onready var side_spring_jump_velocity := (( 2.0 * side_spring_jump_height) / jump_time_to_peak)

var custom_data := Vector2.UP
var dir := Vector2.UP

func _ready() -> void:
	dir = custom_data
	var angle_to_rotate = dir.angle_to(Vector2.UP)
	rotate(angle_to_rotate)
	
	if dir.x != 0: 
		jump_velocity *= -1
		side_spring_jump_velocity *= -1

func _on_body_entered(body) -> void:
	if body is Player:
		$AnimationPlayer.play("boing")
		$Sound.play()
		body.velocity = jump_velocity * dir.normalized()
		if dir.x != 0:
			body.velocity.y = side_spring_jump_velocity
		
		body.spring_jump(dir.x != 0)
