class_name Pushable
extends CharacterBody2D

@export var gravity: float = 50
@export var mass: int = 1
@export var friction_coefficient: float = 100
@export var slide_audio_curve: Curve

@onready var slide_audio: AudioStreamPlayer2D = $SlideAudio

var force := Vector2.ZERO

func _physics_process(delta: float):
	velocity.y += gravity
	
	var friction := -velocity.normalized() * friction_coefficient
	
	var acceleration := (force / mass) + friction
	var delta_velocity := acceleration * delta
	velocity += delta_velocity
	
	move_and_slide()
	
	var velocity_magnitude = velocity.length()
	var max_velocity = force.length() / mass
	var audio_level = slide_audio_curve.sample(velocity_magnitude / max_velocity)
	
	# 2.30259 = log(10) is faster if not calculated each time *shrugs*
	slide_audio.volume_db = 20 * (log(audio_level) / 2.30259) - 10
	
	if velocity.x != 0:
		if not slide_audio.playing:
			slide_audio.play()
	else:
		slide_audio.stop()
	
	if velocity.x < 3 and velocity.x > -3:
		slide_audio.stop()
