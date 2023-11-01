class_name Spring
extends Area2D

@export var shoot_velocity = 500

var custom_data
var dir := Vector2.UP

func _ready():
	dir = custom_data
	var angle_to_rotate = dir.angle_to(Vector2.UP)
	rotate(angle_to_rotate)
	
	if dir.x != 0: shoot_velocity *= -1

func _on_body_entered(body):
	if body is Player:
		$AnimationPlayer.play("boing")
		$Sound.play()
		body.velocity = shoot_velocity * dir.normalized()
		body.spring_jump()
