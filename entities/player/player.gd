class_name Player
extends CharacterBody2D

@export_category("Movement")
@export_subgroup("Misc")
@export var speed := 200
@export var dust_acceleration_curve: Curve
@export_range(0.0, 1.0) var friction := 0.3
@export_range(0.0, 1.0) var air_friction := 0.1
@export_range(0.0 , 1.0) var acceleration := 0.4
@export_subgroup("Jump")
@export var jump_height: float = 100
@export var jump_time_to_peak: float = .5
@export var jump_time_to_descent: float = .4
@export var jump_variable_height: float = 25
@export var wall_jump_pushback := -225
@export var wall_slide_gravity := 100
@export var max_jumps := 1

@export_category("Misc")
@export var walk_particles: PackedScene
@export var jump_particels: PackedScene
@export var land_particels: PackedScene
@export var push_force: float = 20
@export var mass: float = 1

@onready var sprite: Sprite2D = $Sprite
@onready var state_machine: Node = $StateMachine
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var particle_holder: Node2D = $Particles
@onready var audio_controller: Node2D = $AudioController
@onready var blood_particles: CPUParticles2D = $Particles/Blood
@onready var death_audio: AudioStreamPlayer2D = $DeathAudio

@onready var jump_velocity := ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity := ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity := ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var variable_gravity := (jump_velocity * jump_velocity) / (2 * jump_variable_height)

var jumps_remaining := max_jumps
var _prev_flip_h := false
var _is_dead := false

var current_walk_particles: CPUParticles2D
var current_jump_particles: CPUParticles2D
var current_land_particles: CPUParticles2D

func _ready() -> void:
	state_machine.init(self)
	
	current_walk_particles = instantiate_new_particle(walk_particles)
	current_jump_particles = instantiate_new_particle(jump_particels)
	current_land_particles = instantiate_new_particle(land_particels)

func _unhandled_input(event: InputEvent) -> void:
	if GlobalState.camera_moving: return
	if _is_dead: return	
	
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	if GlobalState.camera_moving: return
	if _is_dead: return	
	
	_prev_flip_h = sprite.flip_h
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	if GlobalState.camera_moving: 
		if animator.is_playing():
			animator.pause()
		return
	
	if _is_dead: return
	
	if not animator.is_playing():
		animator.play()
	
	state_machine.process_frame(delta)

func get_gravity() -> float:
	if not Input.is_action_pressed("jump") and velocity.y < 0.0:
		return variable_gravity
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func spawn_walk_dust():
	var percentage = abs(velocity.x) / speed
	var curve_sample = dust_acceleration_curve.sample(percentage)

	if randf() < curve_sample:
		current_walk_particles.emitting = true
		current_walk_particles = instantiate_new_particle(walk_particles)
		#var particle = walk_particles.duplicate().instantiate()
		#$Particles.add_child(particle)

func flip(should_flip: bool):
	sprite.flip_h = should_flip
	$CollisionPolygon2D.scale = Vector2(-1 if should_flip else 1, 1)

func instantiate_new_particle(particle_to_spawn: PackedScene) -> CPUParticles2D:
	var particle = particle_to_spawn.duplicate().instantiate()
	particle_holder.add_child(particle)
	
	return particle

func spawn_jump_dust():
	audio_controller.play_jump_land()
	current_jump_particles.emitting = true
	current_jump_particles = instantiate_new_particle(jump_particels)
	
func spawn_land_dust():
	audio_controller.play_jump_land()
	current_land_particles.emitting = true
	current_land_particles = instantiate_new_particle(land_particels)
	
func die():
	animator.stop()
	_is_dead = true
	sprite.visible = false
	blood_particles.emitting = true
	death_audio.play()
	
	await get_tree().create_timer(blood_particles.lifetime).timeout
	GlobalState.restart_level()
	
func spring_jump():
	state_machine.change_state($StateMachine/Fall)
