extends Area2D

@export var shoot_velocity = -500

var dir = Vector2.UP

func _ready():
	var angle_to_rotate = dir.angle_to(Vector2.UP)
	rotate(angle_to_rotate)

func _on_body_entered(body):
	if body is Player:
		$AnimationPlayer.play("boing")
		$Sound.play()
		body.velocity = shoot_velocity * -dir.normalized()
		body.spring_jump()
