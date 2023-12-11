class_name Player
extends PausableEntity

@export_category("Movement")
@export_subgroup("Misc")
@export var speed := 200
@export var dust_acceleration_curve: Curve
@export_range(0.0, 1.0) var friction := 0.3
@export_range(0.0, 1.0) var air_friction := 0.1
@export_range(0.0 , 1.0) var acceleration := 0.4
@export_range(0.0 , 1.0) var air_acceleration := 0.1
@export_subgroup("Jump")
@export var jump_height: float = 100
@export var jump_time_to_peak: float = .5
@export var jump_time_to_descent: float = .4
@export var jump_variable_height: float = 25
@export var max_jumps := 1
@export var terminal_fall_velocity: float = 1000

@export_subgroup("Wall jump")
@export var wall_jump_height: float = 100
@export var wall_jump_time_to_peak: float = .5
@export var wall_jump_time_to_descent: float = .4
@export var wall_jump_pushback_length: float = 32

@export_category("Misc")
@export var walk_particles: PackedScene
@export var jump_particels: PackedScene
@export var land_particels: PackedScene
@export var push_force: float = 20
@export var mass: float = 1
@export var ceiling_raycast_push_offset: float = 5.0

@onready var sprite: Sprite2D = $Sprite
@onready var state_machine: Node = $StateMachine
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var particle_holder: Node2D = $Particles
@onready var audio_controller: Node2D = $AudioController
@onready var blood_particles: CPUParticles2D = $Particles/Blood
@onready var reverse_blood_particles: CPUParticles2D = $Particles/ReverseBlood
@onready var death_audio: AudioStreamPlayer2D = $DeathAudio
@onready var death_reverse_audio: AudioStreamPlayer2D = $DeathAudio
@onready var ceiling_raycasts: CeilingRaycasts = $CeilingRaycasts
@onready var wall_raycasts: WallRaycasts = $WallRaycasts
@onready var floor_raycasts: FloorRaycasts = $FloorRayCasts

@onready var jump_velocity      := (( 2.0 * jump_height) /  jump_time_to_peak)    * -1.0
@onready var jump_gravity       := ((-2.0 * jump_height) / (jump_time_to_peak    * jump_time_to_peak   )) * -1.0
@onready var fall_gravity       := ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@onready var variable_gravity   := (jump_velocity * jump_velocity) / (2 * jump_variable_height)

@onready var wall_jump_velocity := (( 2.0 * wall_jump_height) / wall_jump_time_to_peak)    * -1.0
@onready var wall_jump_gravity  := ((-2.0 * wall_jump_height) / (wall_jump_time_to_peak    * wall_jump_time_to_peak  )) * -1.0
@onready var wall_slide_gravity := ((-2.0 * wall_jump_height) / (wall_jump_time_to_descent * wall_jump_time_to_descent)) * -1.0
@onready var wall_jump_pushback          := (( 2.0 * wall_jump_pushback_length) / wall_jump_time_to_peak)
@onready var wall_jump_pushback_friction := ((-2.0 * wall_jump_pushback_length) / (wall_jump_time_to_peak * wall_jump_time_to_peak  ))

var jumps_remaining := max_jumps
var is_spring_jump := false
var is_horizontal_spring := false
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
	var return_value: float
	
	if (not Input.is_action_pressed("jump") and velocity.y < 0.0) and not is_spring_jump:
		return_value = variable_gravity
	else:
		return_value = jump_gravity if velocity.y < 0.0 else fall_gravity
	
	return return_value

func get_wall_gravity() -> float:
	return wall_jump_gravity if velocity.y < 0.0 else wall_slide_gravity

func get_wall_jump_friction(wall_dir: int) -> float:
	return wall_jump_pushback_friction if velocity.x > 0.1 * wall_dir else 0.0

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
	
func spring_jump(horizontal: bool) -> void:
	is_spring_jump = true
	if horizontal:
		state_machine.change_state($StateMachine/HorizontalSpringJump)
	else:
		state_machine.change_state($StateMachine/SpringJump)
		
func is_on_wall_only_raycast() -> bool:
	var is_not_on_floor := not is_on_floor() or not (floor_raycasts.left and floor_raycasts.right)
	return ((wall_raycasts.right or wall_raycasts.left) or is_on_wall_only()) and is_not_on_floor

func is_moving_away_from_wall() -> bool:
	var dir := Input.get_axis("walk_left", "walk_right")	
	return (wall_raycasts.left and dir == 1) or \
		(wall_raycasts.right and dir == -1)

func _on_spike_detector_entered(body):
	die()
