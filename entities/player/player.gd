class_name Player
extends PausableEntity

@export var data: PlayerData

@export_category("Particles")
@export var walk_particles: PackedScene
@export var jump_particels: PackedScene
@export var land_particels: PackedScene

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

# jump / gravity vars
@onready var jump_velocity: float = ((2.0 * data.max_jump_height) / data.jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * data.max_jump_height) / (data.jump_time_to_peak * data.jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * data.max_jump_height) / (data.jump_time_to_descent * data.jump_time_to_descent)) * -1.0
@onready var variable_gravity: float = (jump_velocity * jump_velocity) / (2 * data.min_jump_height)

var _current_walk_particles: CPUParticles2D
var _current_jump_particles: CPUParticles2D
var _current_land_particles: CPUParticles2D

func _ready() -> void:
	init()

func init() -> void:
	state_machine.init(self)
	
	if CheckpointManager.has_collected_any():
		state_machine.change_state($StateMachine/Respawn)
	
	var cp_data = CheckpointManager.get_latest_checkpoint_data()
	global_position = cp_data.position
	flip_bool(cp_data.facing_left)
	
	$Camera.update_position()
	
	_current_walk_particles = instantiate_new_particle(walk_particles)
	_current_jump_particles = instantiate_new_particle(jump_particels)
	_current_land_particles = instantiate_new_particle(land_particels)

func unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func process(delta: float) -> void:
	state_machine.process_frame(delta)

func spawn_dust(type: ParticlesType = ParticlesType.Walk) -> void:
	match type:
		ParticlesType.Walk:
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

func flip_bool(should_flip: bool) -> void:
	sprite.flip_h = should_flip
	#$CollisionPolygon2D.scale = Vector2(-1 if should_flip else 1, 1)

func flip(dir: float) -> void:
	sprite.flip_h = dir < 0

func instantiate_new_particle(particle_to_spawn: PackedScene) -> CPUParticles2D:
	var particle = particle_to_spawn.instantiate()
	particle_holder.add_child(particle)
	
	return particle

func _on_spike_detector_entered(_body):
	pass
	#die()

func get_clamped_gravity(delta: float) -> float:
	var gravity = jump_gravity if velocity.y < 0.0 else fall_gravity
	
	if not Input.is_action_pressed("jump") and velocity.y < 0.0:
		gravity = variable_gravity
	
	gravity *= delta
	var new_velocity = velocity.y + gravity
	if new_velocity > 0.0:
		new_velocity = clamp(velocity.y + gravity, 0.0, data.terminal_velocity)
	
	return new_velocity

func is_on_floor_raycasts() -> bool:
	return is_on_floor()# and (floor_raycasts.left or floor_raycasts.right)

func get_movement_velocity(dir: float) -> float:
	var target_speed := dir * data.move_speed
	var accel_rate := data.ground_acceleration if abs(target_speed) > 0 else data.ground_deceleration
	
	# conserve momentum
	if should_conserve_momentum(target_speed):
		accel_rate = 0
	
	var speed_diff := target_speed - velocity.x
	var movement := speed_diff * accel_rate
	return movement

func should_conserve_momentum(target_speed: float) -> bool:
	var velocity_is_greater_then_max: bool = abs(velocity.x) > abs(target_speed)
	var moving_same_dir: bool = sign(velocity.x) == sign(target_speed) 
	var is_moving: bool = abs(target_speed) > 0
	var not_on_ground: bool = not is_on_floor_raycasts()
	
	return data.convserve_momentum and velocity_is_greater_then_max and moving_same_dir and is_moving and not_on_ground
