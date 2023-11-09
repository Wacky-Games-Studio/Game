class_name Player
extends PausableEntity

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
@export var wall_jump_pushback := 225
@export var wall_slide_gravity := 100
@export var max_jumps := 1
@export var terminal_fall_velocity: float = 1000

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
@onready var reverse_blood_particles: CPUParticles2D = $Particles/ReverseBlood
@onready var death_audio: AudioStreamPlayer2D = $DeathAudio
@onready var death_reverse_audio: AudioStreamPlayer2D = $DeathAudio

@onready var jump_velocity := ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity := ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity := ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var variable_gravity := (jump_velocity * jump_velocity) / (2 * jump_variable_height)

var jumps_remaining := max_jumps
var is_spring_jump := false
var _prev_flip_h := false

var _current_walk_particles: CPUParticles2D
var _current_jump_particles: CPUParticles2D
var _current_land_particles: CPUParticles2D

func _ready() -> void:
	init()

func init() -> void:
	state_machine.init(self)
	
	if CheckpointManager.has_collected_any():
		state_machine.change_state($StateMachine/Respawn)
	
	var data = CheckpointManager.get_latest_checkpoint_data()
	global_position = data.position
	flip(data.facing_left)
	
	$Camera.update_position()
	
	_current_walk_particles = instantiate_new_particle(walk_particles)
	_current_jump_particles = instantiate_new_particle(jump_particels)
	_current_land_particles = instantiate_new_particle(land_particels)

func unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func physics_process(delta: float) -> void:
	_prev_flip_h = sprite.flip_h
	state_machine.process_physics(delta)

func process(delta: float) -> void:
	state_machine.process_frame(delta)

func get_gravity() -> float:
	if (not Input.is_action_pressed("jump") and velocity.y < 0.0) or is_spring_jump:
		return variable_gravity
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func spawn_dust(type: ParticlesType = ParticlesType.Walk) -> void:
	match type:
		ParticlesType.Walk:
			var percentage = abs(velocity.x) / speed
			var curve_sample = dust_acceleration_curve.sample(percentage)
			
			if randf() < curve_sample:
				_current_walk_particles.emitting = true
				_current_walk_particles = instantiate_new_particle(walk_particles)
		
		ParticlesType.Jump:
			audio_controller.play_jump_land()
			_current_jump_particles.emitting = true
			_current_jump_particles = instantiate_new_particle(jump_particels)
		
		ParticlesType.Land:
			audio_controller.play_jump_land()
			_current_land_particles.emitting = true
			_current_land_particles = instantiate_new_particle(land_particels)

enum ParticlesType {
	Walk = 0,
	Jump = 1,
	Land = 2
}

func flip(should_flip: bool) -> void:
	sprite.flip_h = should_flip
	$CollisionPolygon2D.scale = Vector2(-1 if should_flip else 1, 1)

func instantiate_new_particle(particle_to_spawn: PackedScene) -> CPUParticles2D:
	var particle = particle_to_spawn.instantiate()
	particle_holder.add_child(particle)
	
	return particle

func die() -> void:
	if state_machine.current_state == $StateMachine/Dead: 
		return
	
	state_machine.change_state($StateMachine/Dead)
	
func spring_jump() -> void:
	state_machine.change_state($StateMachine/Fall)
	is_spring_jump = true
