extends CharacterBody2D

func _on_body_entered(body):
	if body.velocity.y < 0:
		return
	
	$AnimationPlayer.play("break")
