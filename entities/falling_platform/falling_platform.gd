extends CharacterBody2D

@export var gravity = 100

func _physics_process(delta):
	if velocity.y != 0.0:
		move_and_slide()

func _on_body_entered(body):
	if body.velocity.y < 0:
		return
	
	$AnimationPlayer.play("fall")
	
	await $AnimationPlayer.animation_finished
	
	velocity.y = gravity
