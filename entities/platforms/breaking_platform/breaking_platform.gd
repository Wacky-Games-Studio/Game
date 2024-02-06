extends CharacterBody2D

func _on_body_entered(body):
	if body.global_position.y < global_position.y and body.velocity.y < 0:
		return
	
	$AnimationPlayer.play("break")
