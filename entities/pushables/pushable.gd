class_name Pushable
extends CharacterBody2D

@export var gravity: float = 50
@export var mass: int = 1
@export var friction_coefficient: float = 100

var force := Vector2(0, 0)

func _physics_process(delta: float):
	velocity.y += gravity
	
	var friction := -velocity.normalized() * friction_coefficient
	
	var acceleration := (force / mass) + friction
	var delta_velocity := acceleration * delta
	velocity += delta_velocity
	
	move_and_slide()
